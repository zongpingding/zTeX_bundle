\begin{wolframGraphics}[width=.75\linewidth]{example_7.wls}
num = 80;
xls = RandomInteger[{0, 20}, num];
yls = RandomInteger[{0, 20}, num];

xycoor = {xls, yls}//Transpose;
color = {RGBColor["#00A894"], RGBColor["#008896"], RGBColor["#006780"], RGBColor["#2F4858"], RGBColor["#70986B"]};

disks = Table[
    Graphics[{color[[RandomInteger[{1, 5}]]], Disk[xycoor[[i]], RandomReal[{0, 0.05}]*#1+RandomReal[{0, 0.05}]*#2&[xycoor[[i]][[1]], xycoor[[i]][[2]]]]}],
    {i, 1, num}
];
fp91 = disks;
fp92 = ListPlot[xycoor, AspectRatio->(Max[yls])/(Max[xls])];
figure = Show[fp92, fp91];
Export["./ztikz_output/mma_data/example_7.wls.pdf", figure];
\end{wolframGraphics}