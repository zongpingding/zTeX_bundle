\begin{wolframGraphics}[width=.75\linewidth]{example_6.wls}
figure = BarChart[Flatten[Table[{i, j}, {i, 1, 4}, {j, 1, 3}], 1]];
Export["./ztikz_output/mma_data/example_6.wls.pdf", figure];
\end{wolframGraphics}