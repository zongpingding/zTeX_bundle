\begin{mmafig}[width=.3\linewidth]{mma_2.wls}
figure = ParametricPlot3D[
    {1.16^v*Cos[v]*(1+Cos[u]), -1.16^v*Sin[v]*(1+Cos[u]), -2 1.16^v*(1+Sin[u])},
    {u,0,2 Pi},{v,-15,6},
    Mesh->None,
    PlotStyle->{Opacity[0.6],Red},
    PlotRange->All,
    PlotPoints->25,
    Axes->False,
    Boxed->False
]
Export["./ztikz_output/mma_data/mma_2.wls.pdf", figure];
\end{mmafig}