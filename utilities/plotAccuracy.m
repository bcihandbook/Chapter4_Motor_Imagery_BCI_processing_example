function [] = plotAccuracy(Accuracy, SubjectID)

figure();
bar(Accuracy);
axis([0 length(SubjectID)+1 0 110]);
set(gca,'XTick',[1:1:length(SubjectID)]);
set(gca,'XTickLabel',SubjectID,'FontSize',20);
line([0 length(SubjectID)+1], [50 50],'LineWidth',2,'Color','r');
line([0 length(SubjectID)+1], [58 58],'LineWidth',2,'Color','r','LineStyle','--');
xlabel('Subject');
ylabel('Classification Accuracy (%)');