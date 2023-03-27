pageextension 50503 "Job Setup Std. Status" extends "Jobs Setup"
{
    layout
    {
        addafter("Document No. Is Job No.")
        {
            field(DefaultJobStatus; Rec.DefaultJobStatus)
            {
                ApplicationArea = All;
                Caption = 'Standart Projekt Status';
            }
        }
    }

    actions
    {
    }
}