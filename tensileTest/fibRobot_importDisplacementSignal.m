function tensilecomp20210205131013displacement = fibRobot_importDisplacementSignal(filename, dataLines)
%IMPORTFILE Import data from a text file
%  TENSILECOMP20210205131013DISPLACEMENT = IMPORTFILE(FILENAME) reads
%  data from text file FILENAME for the default selection.  Returns the
%  numeric data.
%
%  TENSILECOMP20210205131013DISPLACEMENT = IMPORTFILE(FILE, DATALINES)
%  reads data for the specified row interval(s) of text file FILENAME.
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  tensilecomp20210205131013displacement = importfile("C:\Users\augus\Desktop\fibrobotTemp\tensile_comp_2021-02-05-13-10-13_displacement.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 05-Feb-2021 12:55:03

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["times", "motorpositionnm", "sensorpositionnm"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tensilecomp20210205131013displacement = readtable(filename, opts);

%% Convert to output type
tensilecomp20210205131013displacement = table2array(tensilecomp20210205131013displacement);
end