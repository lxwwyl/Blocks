function WriteCommand(Command, filename)
% WriteCommand writes a new command file.
%
%   WriteCommand(Command, filename) writes the structure Command to the command
%   file specified by filename.
%

fid = fopen(filename, 'w');

fn = fieldnames(Command);
filefields = {...
'Segment file name: %s\n',...
'Station file name: %s\n',...
'Sar file name: %s\n',...
'Block file name: %s\n',...
'Reuse old elastic kernel: %s\n',...
'Old elastic kernel file: %s\n',...
'Save current elastic kernels: %s\n',...
'Fault resolution: %g\n',...
'Poissons ratio: %g\n',...
'Set all uncertainties to 1: %s\n',...
'Station data weight: %g\n',...
'Station data weight minimum: %g\n',...
'Station data weight maximum: %g\n',...
'Station data weight steps: %g\n',...
'Sar data weight: %g\n',...
'Order of estimated sar ramp: %g\n',...
'Slip constraint weight: %g\n',...
'Slip constraint weight minimum: %g\n',...
'Slip constraint weight maximum: %g\n',...
'Slip constraint weight steps: %g\n',...
'Block constraint weight: %g\n',...
'Block constraint weight minimum: %g\n',...
'Block constraint weight maximum: %g\n',...
'Block constraint weight steps: %g\n',...
'Locking depth toggle 2: %g\n',...
'Locking depth toggle 3: %g\n',...
'Locking depth toggle 4: %g\n',...
'Locking depth toggle 5: %g\n',...
'Locking depth override toggle: %s\n',...
'Locking depth override value: %g\n',...
'Apriori block motions relative to: %s\n',...
'Mesh parameter file: %s\n',...
'Triangulated patch files: %s\n',...
'Type of a priori slip constraint (1 = slip values, 2 = coupling fraction): %g\n',...
'Patch slip distribution files: %s\n',...
'Mesh smoothing weight: %g\n',...
'Spatially variable smoothing weighted by resolution: %g\n',...
'Smooth slip components individually (1) or simultaneously (2): %g\n',...
'Constrain slip on [updip downdip lateral] limits: %g %g %g\n',...
'Depth tolerance for finding updip and downdip limits (km): %g\n',...
'Constrained triangular slip weight: %g\n',...
'Strain calculation method: %g\n',...
'Number of monte carlo iterations: %g\n',...
'Inversiontype: %s\n',...
'Inversionparam01: %g\n',...
'Inversionparam02: %g\n',...
'Inversionparam03: %g\n',...
'Inversionparam04: %g\n',...
'Inversionparam05: %g\n',...
'Solution method: %s\n',...
'Lambda value for TVR estimator: %g\n',...
'Dumpall: %s\n'};

structfields = {...
'segFileName',...
'staFileName',...
'sarFileName',...
'blockFileName',...
'reuseElastic',...
'reuseElasticFile',...
'saveKernels',...
'faultRes',...
'poissonsRatio',...
'unitSigmas',...
'stationDataWgt',...
'stationDataWgtMin',...
'stationDataWgtMax',...
'stationDataWgtSteps',...
'sarWgt',...
'sarRamp',...
'slipConWgt',...
'slipConWgtMin',...
'slipConWgtMax',...
'slipConWgtSteps',...
'blockConWgt',...
'blockConWgtMin',...
'blockConWgtMax',...
'blockConWgtSteps',...
'ldTog2',...
'ldTog3',...
'ldTog4',...
'ldTog5',...
'ldOvTog',...
'ldOvValue',...
'aprioriBlockName',...
'mshpFileName',...
'patchFileNames',...
'triSlipConstraintType',...
'slipFileNames',...
'triSmooth',...
'pmagTriSmooth',...
'smoothType',...
'triEdge',...
'triDepthTol',...
'triConWgt',...
'strainMethod',...
'nIter',...
'inversionType',...
'inversionParam01',...
'inversionParam02',...
'inversionParam03',...
'inversionParam04',...
'inversionParam05',...
'solutionMethod',...
'tvrlambda',...
'dumpall'};            

% Match structure fields to file fields
[match, midx] = ismember(fn, structfields);

% A few patch-related things...
numpatch = length(strfind(Command.patchFileNames, ' ')) + 1;
msvidx = strmatch('Mesh smoothing weight:', filefields);
filefields{msvidx} = ['Mesh smoothing weight: ' repmat('%g ', 1, numpatch) '\n'];
numz = min(numpatch, ceil(length(Command.triEdge)/3));
csidx = strmatch('Constrain slip on [', filefields);
filefields{csidx} = ['Constrain slip on [updip downdip lateral] limits: ' repmat('%g ', 1, 3*numz) '\n'];

midx = sort(nonzeros(midx));
% Write data to new command file
for i = 1:length(midx)
   fprintf(fid, filefields{midx(i)}, getfield(Command, structfields{midx(i, :)}(:)'));
end

fclose(fid);
