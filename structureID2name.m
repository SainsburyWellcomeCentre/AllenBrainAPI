function [names,ARA_JSON]=structureID2name(structIDs,ARA_JSON)
% convert a list of ARA structure IDs to a cell array of names
%
% function [names,ARA_JSON]=structureID2name(structIDs,ARA_JSON)
%
% Purpose
% Each Allen Reference Atlas (ARA) brain area is associated with a unique
% number (structure ID). This function converts the ID to a an area name.
% 
%
% Inputs
% structIDs - a vector (list) of integers corresponding to brain structure ids 
% ARA_JSON - [optional] the ARA JSON imported as a structure. You may have a local 
%            copy of this, in which case you could J = loadjson(PATH)
%            if this is left bank, the JSON is pulled off the web and cached as 
%            both a text file and a MATLAB structure.
%
%
% Outputs
% names - a list of brain area names
% ARA_JSON - the JSON structure
%
% Rob Campbell



if ~exist('loadjson')
   disp('Please install JSONlab from the FEX') 
   return
end



if nargin<2
	cachedJSON = '/tmp/cachedARA_JSON.json';
	cachedJSONstruct = '/tmp/cachedARA_JSON.mat';

	if ~exist(cachedJSON,'file') %download and cache the JSON file
		JSON_URL = 'http://api.brain-map.org/api/v2/structure_graph_download/1.json';
		fprintf('Getting JSON from %s and caching to %s%s\n',JSON_URL, fileparts(cachedJSON),filesep)

		[~,status] = urlwrite(JSON_URL,cachedJSON);
		if ~status
			error('Failed to get JSON from URL %s', JSON_URL)
		end

		ARA_JSON = loadjson(cachedJSON);
	
		save(cachedJSONstruct,'ARA_JSON')
	else
		load(cachedJSONstruct)
	end
end





%flatten the JSON and keep only the rows we care about
flattened = looper(ARA_JSON.msg{1});

allIDs = [flattened{:,1}];

%loop through and find all the IDs
names={};
for ii=1:length(structIDs)
	f=find(allIDs == structIDs(ii));
	if isempty(f)
		continue
	end
	if length(f)>1
		error('found more than one ID index')
	end
	names{ii} = flattened{f,2};
end




function out = looper(json,out)
% looper searches recursively through the structure to build the flattened cell array
if nargin<2
	out{1,1} = json.id;
	out{1,2} = json.name;
	looper(json,out);
end

for ii=1:length(json.children)
	c = json.children{ii};
	tmp{1,1} = c.id;
	tmp{1,2} = c.name;
	out = [out;tmp];
	out = looper(c,out);
end

