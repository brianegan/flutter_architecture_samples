# Line Counts

Though not the only factor or even most important factor, the amount of code it
takes to achieve a working product is an important consideration when comparing
frameworks.

While this is an imperfect line count comparison -- some of the samples contain
a bit more functionality than others -- it's a pretty fair comparison overall:
All of the apps implement the spec using the provided `app_core` and
`todos_repository`, implement the same Flutter keys, use the same theme, are
formatted with dartfmt, and all comments / blank lines / generated code are
excluded.

For authors of frameworks or samples (hey, I'm one of those!): Please do not 
take this comparison personally, nor should folks play "Code Golf" with the
samples to make them smaller, unless doing so improves the application overall.  
  
| *Sample* | *LOC (no comments)* |
|--------|-------------------|
| scoped_model | 778 |
| mobx | 815 |
| inherited_widget | 832 |
| mvc | 842 |
| vanilla | 842 |
| frideos_library | 878 |
| simple blocs | 1076 |
| built_redux | 1172 |
| bloc | 1186 |
| mvu | 1191 |
| bloc library | 1214 |
| mvi | 1244 |
| redux | 1362 |
| firestore_redux | 1429 |

Note: This file was generated on 2020-01-08 13:03:29.947330Z using `scripts/line_counter.dart`.  

