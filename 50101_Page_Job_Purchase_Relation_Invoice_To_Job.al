page 50501 "Inv.-Job Relaction"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "Job Purchase Invoice Relation";

    layout
    {
        area(Content)
        {
            repeater(Item)
            {
                field(JobID; Rec.JobID)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    //DrillDownPageId = "Job Card";
                    TableRelation = Job."No.";
                    Caption = 'Projekt Nr.';

                    trigger OnDrillDown()
                    var
                        Jobs: Record Job;
                    begin
                        Jobs.SetRange("No.", Rec.JobID);
                        Page.Run(Page::"Job Card", Jobs);
                    end;
                }
                field(PruchaseInvoiceID; Rec.PruchaseInvoiceID)
                {
                    Caption = 'Einkaufsrechnungs Nr.';
                    Editable = false;
                    ApplicationArea = All;
                    DrillDown = true;
                    //DrillDownPageId = "Purchase Invoice";
                    TableRelation = "Purchase Header"."No.";

                    trigger OnDrillDown()
                    var
                        Invoices: Record "Purchase Header";
                    begin
                        Invoices.SetRange("No.", Rec.PruchaseInvoiceID);
                        Page.Run(Page::"Purchase Invoice", Invoices);
                    end;
                }
            }
        }
    }

    actions
    {
    }
}