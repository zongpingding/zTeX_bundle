\begin{wolframGraphics}[width=.75\linewidth]{example_3.wls}
figure = NumberLinePlot[
    {Interval[{5, Infinity}], Interval[{2, 7}]}, 
    AxesStyle->Arrowheads[{0, 0.03}]
];
Export["./ztikz_output/mma_data/example_3.wls.pdf", figure];
\end{wolframGraphics}