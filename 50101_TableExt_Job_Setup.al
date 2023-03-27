tableextension 50501 "Job Setup Std. Status" extends "Jobs Setup"
{
    fields
    {
        field(50000; DefaultJobStatus; Enum "Job Status")
        {
            Caption = 'Standart Status';
        }
    }
}