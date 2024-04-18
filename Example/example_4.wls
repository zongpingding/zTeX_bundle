\begin{wolframGraphics}[width=.75\linewidth]{example_4.wls}
fvec = VectorPlot[{1, x^2}, {x, -4, 4}, {y, -4, 4}, AxesOrigin->{0, 0}, Axes->False, Frame->False];
fp6 = Plot[1/3*x^3, {x, -2, 2}, PlotStyle->Red,  AxesStyle->Arrowheads[{0, 0.03}] ];
figure = Show[fp6, fvec];
Export["./ztikz_output/mma_data/example_4.wls.pdf", figure];
\end{wolframGraphics}