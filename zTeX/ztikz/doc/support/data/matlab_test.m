x = 1:0.1:2*pi;
y = sin(x);
figure('visible','off')
plot(x, y, 'r-');
exportgraphics(gcf, 'myfig.pdf')