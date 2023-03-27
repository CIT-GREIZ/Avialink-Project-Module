page 50500 "Job-Inv. Relaction"
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
                    Editable = false;
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
                    ApplicationArea = All;
                    DrillDown = true;
                    //DrillDownPageId = "Purchase Invoice";
                    TableRelation = "Purchase Header"."No.";
                    Caption = 'Einkaufsrechnungs Nr.';

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