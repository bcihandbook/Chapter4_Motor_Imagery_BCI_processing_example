function [] = showTopographicComparisonRHLH(gapsd_rh, gapsd_lh, chanlocs16)

figure();
subplot(2,1,1);topoplot(mean(gapsd_rh(:,[3 4 5 6]),2)-...
    mean(gapsd_lh(:,[3 4 5 6]),2),chanlocs16);
title('$\mu$ band, Right hand vs Left Hand','Interpreter','latex');
colorbar;

subplot(2,1,2);topoplot(mean(gapsd_rh(:,[8 9 10 11]),2)-...
    mean(gapsd_lh(:,[8 9 10 11]),2),chanlocs16);
title('$\beta$ band, Right hand vs Left Hand','Interpreter','latex');
colorbar;