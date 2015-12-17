function result = getProjectionDataFromExperiment(expID)
% get projection data from Allen experiment ID
%
% function data = getProjectionDataFromExperiment(expID)
%
% Purpose
% Get projection information from ARA sample brain(s) given one or more experiment IDs.
% These can be searched for using findAllenExperiments
%
% Inputs
% 'expID' - a scalar or vector defining one or more experiment IDs to extract using the ARA API.
%
%
% Outputs
% data - the connectivity data in a cell array [of length equal to length(expID)] of structures
%
% 
% Rob Campbell - Basel 2015
%
% Also see: 
%  findAllenExperiments
%
% requires JSONlab from the

if ~exist('loadjson')
   disp('Please install JSONlab from the FEX') 
   return
end

if ~isnumeric(expID)
    error('expID should be numeric')
end

%Build the URL 
%this is the base URL
url = 'http://connectivity.brain-map.org/api/v2/data/ProjectionStructureUnionize/query.json?criteria=[section_data_set_id$eq%d]&num_rows=all';


for ii=1:length(expID)
    if length(expID)>1
        fprintf('Getting data for experiment ID %d\n',expID(ii))
    end
    page{ii} = urlread(sprintf(url,expID(ii)));
end

%parse the JSON data into a cell array of structures
n=1;
for ii=1:length(page)
    tmp = loadjson(page{ii});
    if tmp.success
        %Convert to an array of structures because cell arrays are annoying
        for jj=1:length(tmp.msg)
            result{n}(jj)=tmp.msg{jj};
        end

    end
    n=n+1;
end

