function [img_out, removed] = bwremove(seed, mask)
% BWREMOVE Removes objects in binary image.
%   BW3 = BWREMOVE(BW1,BW2) returns a binary image BW3 where the objects 
%   from the mask image that overlap the seed image are removed. Both the 
%   seed BW1 and the mask BW2 images can have multiple blobs.
%   Blobs are connected sets of "on" pixels (i.e., having value of 1).
% 
%   [BW3, BW4] = BWREMOVE(BW1,BW2) returns the binary image BW4 which
%   contains the removed blob(s).
% 
%   Class Support
%   ------------- 
%   The input images BW1 and BW2 can be logical or any numeric type and 
%   must be 2-D and nonsparse. The output images BW3 and BW4 are logical.
%
%   Example
%   -------
%       BW1 = imread('text.png');
%       BW2 = zeros(size(BW1));
%       BW2(34,126) = 1;
%       BW3 = bwremove(BW1,BW2);
%       figure, imshow(BW1)
%       figure, imshow(BW3)
%
%   See also BWSELECT, BWLABELN, REGIONPROPS, IMADD.

%   Author: Mathijs van Vulpen

if nargin<2
  error('bwremove needs two arguments, one mask and one seed.');
end

if size(seed,3)>1 || size(mask,3)>1
    error('bwremove accepts only 2 dimensional images');
end

if ~islogical(seed)
  seed = im2bw(seed);
end

if ~islogical(mask)
  mask = im2bw(mask);
end

img_out = seed;

% make an image containing only the overlapping pixels that are 1
seed_and_mask = seed & mask;

% get the points that define the blobs in the seed image
seed_and_mask_labeled = bwlabeln(seed_and_mask);
STATS = regionprops(seed_and_mask_labeled,'Centroid');

% transform STATS struct to matrix with points (the fast way)
% mask_indices = cell2mat(struct2cell(STATS)'); seems to be slower
seed_indices = [];
for p=1:length(STATS)
  seed_indices = cat(1,seed_indices,[STATS(p,1).Centroid(2),STATS(p,1).Centroid(1)]);
end

removed = zeros(size(seed));

% for every point in seed_indices
for i=1:size(seed_indices,1)
  % select the corresponding blob
  remove_me = bwselect(seed,seed_indices(i,2),seed_indices(i,1));
  
  % add removed blob to removed blob image
  removed = imadd(im2bw(removed), remove_me);
end

% delete the blob from the seed image
img_out = imsubtract(seed,im2bw(removed));