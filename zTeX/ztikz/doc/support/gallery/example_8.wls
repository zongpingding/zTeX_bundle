\begin{wolframGraphics}[width=.75\linewidth]{example_8.wls}
figure = Graphics3D[{
    Blue, Opacity[0.5], Sphere[{0.5, 0.5, 0}, 0.5],
    Blue, Opacity[0.5], Sphere[{-0.5, -0.5, 0}, 0.5],
    Blue, Opacity[0.5], Sphere[{0.5, -0.5, 0}, 0.5], 
    Blue, Opacity[0.5], Sphere[{-0.5, 0.5, 0}, 0.5],
    Blue, Opacity[0.5], Sphere[{0, 0, 0.5}, 0.5],
    Blue, Opacity[0.5], Sphere[{0, 0, -0.5}, 0.5],
    Green,Sphere[{0,0,0}, 0.75]
    }, Boxed->False
];
Export["./ztikz_output/mma_data/example_8.wls.pdf", figure];
\end{wolframGraphics}