function [SelFeatInd, fvec, fvec_rh, lbl_rh, fvec_lh, lbl_lh] = ...
    FeatureSelection(lpsd, labels, ChannelLabels, chanlocs16)

% Reshape dataset for feature selection
fvec = reshape(lpsd,[size(lpsd,1) size(lpsd,2)*size(lpsd,3)]);
fvec_rh = fvec(find(labels==1),:);
lbl_rh = ones(size(fvec_rh,1),1);
fvec_lh = fvec(find(labels==2),:);
lbl_lh = 2*ones(size(fvec_lh,1),1);

DPrhlh = cva_tun_opt([fvec_rh;fvec_lh],[lbl_rh;lbl_lh]);
DPMrhlh = reshape(DPrhlh,size(lpsd,2),size(lpsd,3));

figure();
subplot(3,1,1);imagesc(DPMrhlh);colorbar;
title('Discriminancy Right vs Left hand');
set(gca,'XTick',[1:1:23]);
set(gca,'XTickLabel',[4:2:48],'FontSize',20);
set(gca,'YTick',[1:1:16]);
set(gca,'YTickLabel',ChannelLabels,'FontSize',10);
subplot(3,1,2);topoplot(mean(DPMrhlh(:,[4:6]),2),chanlocs16);title('$\mu$ band','Interpreter','latex');
subplot(3,1,3);topoplot(mean(DPMrhlh(:,[8:11]),2),chanlocs16);title('$\beta$ band','Interpreter','latex');

% Automatic way to select the features: simply rank according to
% discriminant power and select the N best
NSelFeat = 5;
[~, SortInd] = sort(DPrhlh,'descend');
SelFeatInd = SortInd(1:NSelFeat);

%[SelFeatCh, SelFeatFreq] = ind2sub([size(lpsd,2), size(lpsd,3)],SelFeatInd); % Useful to compare with feature map
