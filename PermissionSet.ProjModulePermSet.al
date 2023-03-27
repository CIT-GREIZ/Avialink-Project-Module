permissionset 50500 "Proj Module Perm Set"
{
    Assignable = true;
    Caption = 'Proj Module Perm Set', MaxLength = 30;
    Permissions =
        table "Job Purchase Invoice Relation" = X,
        tabledata "Job Purchase Invoice Relation" = RMID,
        page "Job-Inv. Relaction" = X,
        page "Inv.-Job Relaction" = X;
}
