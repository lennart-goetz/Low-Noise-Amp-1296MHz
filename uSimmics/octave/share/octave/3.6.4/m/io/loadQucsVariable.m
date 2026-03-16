% [data, depNames, depData] = loadQucsVariable (filename, varname)
% Read the variable 'varname' from a uSimmics dataset file.
% The cell array 'depNames' contains the names of the dependencies,
% 'depData' contains its values.
%
% Example:
% [x, names, dep] = loadQucsVariable ("actest.dat", "out.v")
% x = 
%   1 + 0.5i
%   2 + 1.5i
% names = frequency
% plot(dep{1}, x)
%
% Copyright 2010...2022 by Michael Margraf
% This is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License (GPL v2).
% NO WARRANTY AT ALL!
%

function [data, depNames, depData] = loadQucsVariable(filename, varName)
    fid = fopen(filename, "rb");
    if fid < 0
        error("Cannot open data file.")
        return
    end

    if strcmp(fscanf(fid, "%8s", "C"), "QucsData") == 0
        error("File is not a Qucs data file.")
        fclose(fid);
        return
    end

    version = fread(fid, 1, "int32", 0, "ieee-le");
    headerSize = fread(fid, 1, "int32", 0, "ieee-le");

    % load header containing a list of all variables in the file
    header = fread(fid, headerSize, "uchar");

    pos = 0;
    type = 0;
    count = 0;
    index = 0;
    % search for the variable
    while index+9 <= headerSize
        pos = pos + 2*count - bitget(type, 3)*count;
        type  = header(index+1) + 256*(header(index+2) + 256*(header(index+3) + 256*header(index+4)));
        count = header(index+5) + 256*(header(index+6) + 256*(header(index+7) + 256*header(index+8)));

        name = "";
        depNames = "";
        index = index + 9;
        while header(index) > 0
            name = [name char(header(index))];
            index = index + 1;
        end
        if bitget(type, 2) == 1  % is dependent variable?
            index = index + 1;
            while header(index) > 0
                depNames = [depNames char(header(index))];
                index = index + 1;
            end
        end
        if strcmp(name, varName) == 1
            break  % variable found!
        end
    end

    if strcmp(name, varName) == 0
        error("Variable not found.")
        fclose(fid);
        return
    end

    fseek(fid, 8*pos, SEEK_CUR);
    if bitget(type, 3) == 0  % complex-valued numbers?
        count = 2*count;
        data = fread(fid, count, "double", 0, "ieee-le");
        data = data(1:2:count-1) + j*data(2:2:count);
    else
        data = fread(fid, count, "double", 0, "ieee-le");
    end

    depNames = strsplit(depNames, " ");  % convert to cell array of strings

    % search for the dependency variables
    len = [];
    depData = cell(length(depNames));
    for n = 1:length(depNames)
        count = str2double(depNames{n});
        if ~isnan(count)  % size of s-parameter matrix?
            len = [len count];
            continue
        end

        pos = 2;
        type = 0;
        count = 0;
        index = 0;
        fseek(fid, headerSize, SEEK_SET);
        % get the dependency variable in header
        while index+9 <= headerSize
            pos = pos + 2*count - bitget(type, 3)*count;
            type  = header(index+1) + 256*(header(index+2) + 256*(header(index+3) + 256*header(index+4)));
            count = header(index+5) + 256*(header(index+6) + 256*(header(index+7) + 256*header(index+8)));

            name = "";
            index = index + 9;
            while header(index) > 0
                name = [name char(header(index))];
                index = index + 1;
            end
            if bitget(type, 2) == 1  % is dependent variable?
                index = index + 1;
                while header(index) > 0  % overread dependency names
                    index = index + 1;
                end
            end
            if strcmp(name, depNames{n}) == 1  % variable found?
                fseek(fid, 8*pos, SEEK_CUR);
                len = [len count];
                depData{n} = fread(fid, count, "double", 0, "ieee-le");
                break
            end
        end
    end
    if ~isempty(len)
        data = reshape(data, len);
    end

    fclose(fid);
endfunction
