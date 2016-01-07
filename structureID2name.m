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
% ARA_LIST - [optional] the first output of getAllenStructureList
%
%
% Outputs
% names - a list of brain area names
% ARA_LIST - the CSV data in the form of a cell array
%
%
% Example
%
% >> structureID2name(644) 
%
% ans = 
%
%    'Somatomotor areas, Layer 6a'
%
%
% Rob Campbell
%
% See also:
% getAllenStructureList


if nargin<2
	ARA_LIST = getAllenStructureList;
end


%loop through and find all the IDs
names={};

for ii=1:length(structIDs)
	f=find(ARA_LIST.id == structIDs(ii));
	if isempty(f)
		continue
	end
	if length(f)>1
		error('found more than one ID index')
	end
	names{ii} = ARA_LIST.name{f};
end

