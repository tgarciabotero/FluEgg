function savefaststruct(filename, savestruct)
% savefaststruct: fast saves of large arrays to .mat files
%
% Matlab's 'save' command can be very slow when saving large arrays,
% because by default Matlab attempts to use compression. This function
% provides a much faster alternative, at the cost of larger files.
%
% 'savefaststruct' version saves variables from a structure
% this avoids the need for evalin which does not work inside
% parfor etc. 

% Copyright 2013 by Timothy E. Holy

  % Extract the variable values
  varnames = fieldnames(savestruct);
  vars = cell(size(varnames));
  for i = 1:numel(vars)
    vars{i} = savestruct.(varnames{i})
  end
  
  % Separate numeric arrays from the rest
  isnum = cellfun(@(x) isa(x, 'numeric'), vars);
  
  % Append .mat if necessary
  [filepath, filebase, ext] = fileparts(filename);
  if isempty(ext)
    filename = fullfile(filepath, [filebase '.mat']);
  end
  
  create_dummy = false;
  if all(isnum)
    % Save a dummy variable, just to create the file
    dummy = 0; %#ok<NASGU>
    save(filename, '-v7.3', 'dummy');
    create_dummy = true;
  else
    s = struct;
    for i = 1:numel(isnum)
      if ~isnum(i)
        s.(varnames{i}) = vars{i};
      end
    end
    save(filename, '-v7.3', '-struct', 's');
  end
  
  % Delete the dummy, if necessary, just in case the user supplied a
  % variable called dummy
  if create_dummy
    fid = H5F.open(filename,'H5F_ACC_RDWR','H5P_DEFAULT');
    H5L.delete(fid,'dummy','H5P_DEFAULT');
    H5F.close(fid);
  end
  
  % Save all numeric variables
  for i = 1:numel(isnum)
    if ~isnum(i)
      continue
    end
    varname = ['/' varnames{i}];
    h5create(filename, varname, size(vars{i}), 'DataType', class(vars{i}));
    h5write(filename, varname, vars{i});
  end
end
