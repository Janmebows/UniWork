hold on;
x=[0,1];
Aus = [0.871, 0.591];
Ban = [0.14, 1];
Can = [0.963, 0.642];

line (x, Aus,'Color', 'green', 'LineWidth', 2);
line (x,Ban, 'Color', 'blue', 'LineWidth', 2);
line (x, Can, 'Color', 'yellow', 'LineWidth', 2);
line ([0.6969, 0.6969], x,'Color', 'red', 'LineStyle', '--');

xlabel("Value of Profit (%)");
ylabel("Factory Value");
legend ("Australia", "Bangladesh", "Canada");