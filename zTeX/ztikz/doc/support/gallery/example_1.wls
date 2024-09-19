\begin{wolframGraphics}[width=.75\linewidth]{example_1.wls}
fp1 = ContourPlot[x^2 + y^2 == 4, {x, -1.3, 0.6}, {y, -2.4, 3.2}, AspectRatio->(2.4+3.2)/(1.3+0.6), ContourStyle->Red];
fp2 = ContourPlot[x^2 + y^2 == 4, {x, -3, 3}, {y, -3, 3}, AspectRatio->1, ContourStyle->RGBColor["#00C0A3"], AxesOrigin->{0, 0}, Axes->True];

fp3 = ContourPlot[{x^2 + y^2 == 4, x^2 + Sin[y] == 1},
    {x, -2.5, 2.5}, {y, -3, 3},
    ContourStyle->{
        {RGBColor["#00C0A3"], Thickness[0.15]},
        {RGBColor["#FF9671"], Thickness[0.05]}
    },
    AspectRatio->(3+3)/(2.5+2.5),
    AxesOrigin->{0,0},
    Axes->True,
    Frame->False,
    AxesStyle->Arrowheads[{0,0.03}]
]
figure = Show[fp2, fp1, fp3];
Export["./ztikz_output/mma_data/example_1.wls.pdf", figure];
\end{wolframGraphics}