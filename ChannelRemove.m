Srclist=[7 8 15 16];
Detlist=[1 2 3 5 17 18 19 21];
RemoveNoisyChannel(Srclist, Detlist);

% Check wether the channels are removed
for i=1:length(raw)
    disp(size(raw(i).data,2));
end

