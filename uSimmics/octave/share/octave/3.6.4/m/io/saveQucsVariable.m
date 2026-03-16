% ok = saveQucsVariable (filename, var, dep1, dep2, ...)
% Saves the vector 'var' and its dependencies 'dep1'...
% into the uSimmics dataset file with name 'filename'.
% Returns 'true' if successful.
%
% Example with single dependency (2D):
% ok = saveQucsVariable ("octdata.dat", y, x)
% ok = 1
%
% Example with two dependencies (3D):
% ok = saveQucsVariable ("octdata.dat", y, x1, x2)
% ok = 1
%
% Example with s-parameters:
% ok = saveQucsVariable ("octdata.dat", S, frequency, 2, 2)
% ok = 1
%
% Copyright 2010...2022 by Michael Margraf
% This is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License (GPL v2).
% NO WARRANTY AT ALL!
%

function ok = saveQucsVariable(filename, var, varargin)
  ok = false;

  if nargin < 3
      error("Too few input parameters.")
      return
  end

  lenDep = 1;
  for i=1:length(varargin)
      if length(varargin{i}) > 1
          lenDep = lenDep * length(varargin{i});
      else
          lenDep = lenDep * varargin{i};
      end
  end
  if numel(var) ~= lenDep
      error("Independent and dependent variables must have the same size.")
      return
  end

  [m, n] = size(var);
  if (m > 1) && (n > 1)
      var = var(:);  % flatten matrix data
      if nargin == 4
        if (m ~= length(varargin{1})) || (n ~= length(varargin{2}))
          error("Independent variable sizes don't match matrix size.")
          return
        end
      end
  end

  header_size = 11 + (nargin-2)*8;
  fid = fopen(filename, "wb");
  if fid < 0
      error("Cannot create data file.")
      return
  end

  % determine names of variables
  varName = inputname(2);
  if isvarname(varName) == false
      varName = "var";
  end
  depNames = "";
  for i=3:nargin
      if i > 3 depNames = [depNames " "]; end
      if isvarname(inputname(i)) == false
          if length(varargin{i-2}) > 1
              if nargin == 3
                  depNames = [depNames "dep"];
              else
                  depNames = [depNames sprintf("dep%d", i)];;
              end
          else
              depNames = [depNames num2str(varargin{i-2})];  % for s-parameter matrix
              header_size = header_size - 8 - 2; % don't save matrix index as variable
          end
      else
          depNames = [depNames inputname(i)];
      end
  end

  % write prologue
  fputs(fid, "QucsData"); % file ID
  fwrite(fid, uint32(0x02040000), "int32", 0, "ieee-le"); % version
  header_size = header_size + 2*length(depNames) + length(varName);
  fwrite(fid, uint32(header_size), "int32", 0, "ieee-le");

  % write header
  for i=3:nargin  % all independent variables
      if length(varargin{i-2}) > 1
          fwrite(fid, uint32(5), "int32", 0, "ieee-le"); % type of variable = real-valued
          fwrite(fid, uint32(length(varargin{i-2})), "int32", 0, "ieee-le"); % size of variable
          fputs(fid, inputname(i));
          fwrite(fid, uint8(0), "int8"); % string termination
      end
  end

  fwrite(fid, uint32(3), "int32", 0, "ieee-le"); % type of variable = dependent
  fwrite(fid, uint32(length(var)), "int32", 0, "ieee-le"); % size of variable
  fputs(fid, varName);
  fwrite(fid, uint8(0), "int8"); % string termination
  fputs(fid, depNames);
  fwrite(fid, uint8(0), "int8"); % string termination

  % write data
  for i=1:length(varargin)  % all independent variables
      if length(varargin{i}) > 1
          fwrite(fid, varargin{i}, "double", 0, "ieee-le"); % data of dependency
      end
  end
  if m == 1
    cvar = [real(var); imag(var)];
  else
    cvar = [real(var).'; imag(var).'];
  end
  fwrite(fid, cvar, "double", 0, "ieee-le"); % data of variable

  fclose(fid);
  ok = true;
endfunction
