/- This script contains upd functionality for non-standard setups of KDB processes that do not use a Tickerplant.
/- The idea is to not keep a large TP file but also to be able to quickly append data to a keyed table in-memory for fast access.
/- This is useful for data with very large volumes where we only want to keep the latest record and we do not care about the previous updates for a specific key.
/- Data comes from upstream in the following format:
/- upd[tablename;data]

/- Config variables
updMap:()!();
RetentionDaysMap:()!();
IsKeyedMap:()!();
KeepInMemoryMap:()!();
SaveTypeMap:()!();
AcceptedRangeMap:()!();
AcceptBeyondRangeMap:()!();
CustomUpdFuncMap:()!();

upd:{[tablename;table] updMap[tablename][tablename;table]};

.common.initMemTab:{[tablename]


 }