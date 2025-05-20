\begin{wolframGraphics}[width=.35\linewidth]{mma_3.wls}
figure = ContourPlot[{x^2 + y^2 == 4, x^2 + Sin[y] == 1}, 
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
Export["./ztikz_output/mma_data/mma_3.wls.pdf", figure]
\end{wolframGraphics}