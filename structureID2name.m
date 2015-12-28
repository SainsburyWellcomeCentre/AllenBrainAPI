function [names,ARA_LIST]=structureID2name(structIDs,ARA_LIST)
% convert a list of ARA structure IDs to a cell array of names
%
% function [names,ARA_LIST]=structureID2name(structIDs,ARA_LIST)
%
% Purpose
% Each Allen Reference Atlas (ARA) brain area is associated with a unique
% number (structure ID). This function converts the ID to a an area name.
% 
%
% Inputs
% structIDs - a vector (list) of integers corresponding to brain structure ids 
% ARA_LIST - [optional] the result of reading the brain areas as a CSV file. 
%			 e.g.
%            url='http://api.brain-map.org/api/v2/data/Structure/query.csv?criteria=[graph_id$eq1]&num_rows=all'
%            L=urlread(url);
%            is missing, this is is read automatically and cached.
%
%
% Outputs
% names - a list of brain area names
% ARA_LIST - the raw CSV data
%
% Rob Campbell



if nargin<2

	cachedURL = '/tmp/cachedARA_LIST.csv';
	cachedNameList = '/tmp/cachedARA_LIST.mat';
	if ~exist(cachedURL,'file') %download and cache the JSON file
		url='http://api.brain-map.org/api/v2/data/Structure/query.csv?criteria=[graph_id$eq1]&num_rows=all';
		fprintf('Getting JSON from %s and caching to %s%s\n',url, fileparts(cachedURL),filesep)

		[~,status] = urlwrite(url,cachedURL);
		if ~status
			error('Failed to get JSON from URL %s', url)
		end
		ARA_LIST = readCachedURL(cachedURL);
		save(cachedNameList,'ARA_LIST')
	else
		load(cachedNameList);
	end



end


%loop through and find all the IDs
names={};
allIDs = cellfun(@str2num,ARA_LIST(:,1));


for ii=1:length(structIDs)
	f=find(allIDs == structIDs(ii));
	if isempty(f)
		continue
	end
	if length(f)>1
		error('found more than one ID index')
	end
	names{ii} = ARA_LIST{f,2};
end





%--------------------------------------------------
function data = readCachedURL(fname)
% read csv file containing data from web into a cell array 
% this sub-function maybe should be moved to an stand-alone one at some point

fid = fopen(fname);

tline = fgetl(fid); %read and dump first line that contains the column headings

data={};
while ischar(tline)
	tline=fgetl(fid);
	if ischar(tline)
		tmp=strsplit(tline,',');
		data = [data;[tmp(1),tmp(end)]]; %keep only id, atlas id, and the structure name
	end

end

fclose(fid);