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
take this comparison personally, nor should folks play "Code Golf" in an attempt
to reduce the lines of code, unless doing so improves the application overall.  
  
| *Sample* | *LOC (no comments)* |
|--------|-------------------|
| scoped_model | 779 |
| mobx | 815 |
| inherited_widget | 829 |
| mvc | 839 |
| vanilla | 842 |
| frideos_library | 881 |
| simple blocs | 1076 |
| built_redux | 1170 |
| mvu | 1181 |
| bloc | 1188 |
| bloc library | 1215 |
| mvi | 1244 |
| redux | 1365 |
| firestore_redux | 1428 |

Note: This file was generated on 2020-01-08 10:08:26.937197Z using `scripts/line_counter.dart`.  

