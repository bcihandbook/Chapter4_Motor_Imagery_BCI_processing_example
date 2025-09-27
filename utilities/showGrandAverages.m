function [gapsd_rh, gapsd_lh] = showGrandAverages(lpsd, labels, ChannelLabels, freqs)

for pch=1:size(lpsd,2)
    gapsd_rh(pch,:) = mean( squeeze(lpsd(find(labels==1),pch,:)), 1);
    gapsd_lh(pch,:) = mean( squeeze(lpsd(find(labels==2),pch,:)), 1);
end
figure();
subplot(2,1,1);plot(freqs,gapsd_rh);xlabel('Frequency (Hz)');ylabel('logPSD');legend(ChannelLabels);
subplot(2,1,2);plot(freqs,gapsd_lh);xlabel('Frequency (Hz)');ylabel('logPSD');