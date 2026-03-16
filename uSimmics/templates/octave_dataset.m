
datafile = strcat(mfilename(), ".dat");
displayfile = strcat(mfilename(), ".dpl");

% load data from simulation result
[var, names, dep] = loadQucsVariable(datafile, "net.v");
printf("number of dependencies: %d\n", length(names))
for n=1:length(names)
  disp(names{n});
end
freq = dep{1};  % first dependency
temp = dep{2}; % second dependency

% save variable with two dependencies into dataset file
saveQucsVariable(datafile, var, freq, temp);

% display variable in 2D diagram
plot(freq, abs(var))
title("Simulation Result");
xlabel("frequency");
ylabel("output voltage (V)");

% display variable in 3D diagram
figure
[x, y] = meshgrid(freq, temp);
mesh(x', y', abs(var))
title("Simulation Result");
xlabel("frequency (kHz)");
ylabel("scaling factor");
zlabel("output voltage (V)");

% load s-parameters
[S, names, deps] = loadQucsVariable(datafile, "S");
frequency = deps{1} / 1e9;  % convert to GHz
S11 = S(:,1,1);
S21 = S(:,1,2);  % indeces are exchanged! (matrix is transposed)

% save result back into dataset file
saveQucsVariable(datafile, S, frequency, 2, 2);

% open data display file
printf("\t@Gui.open %s\n", displayfile);
