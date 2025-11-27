/ 10-level order book – keyed table (production standard)
book:([] 
  time:`timespan$();
  sym:`symbol$();
  side:`$();           / `bid or `ask
  price:`float$();
  size:`float$();
  level:`int$()        / 1 = best, 10 = deepest
 )

/ Make it keyed – sym+side+level unique → perfect upsert
book:(`sym`side`level)#book

-1"book schema loaded – keyed table ready";
