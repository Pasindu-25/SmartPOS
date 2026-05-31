package com.smartpos.model;
import java.sql.Timestamp;

public class Sale {
    private int saleId;
    private String invoiceNumber;
    private int userId; // Cashier ID
    private String cashierName;
    private double netTotal;
    private String paymentMethod;
    private double amountTendered;
    private double changeDue;
    private Timestamp saleDate;

    public int getSaleId() { return saleId; }
    public void setSaleId(int saleId) { this.saleId = saleId; }

    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCashierName() { return cashierName; }
    public void setCashierName(String cashierName) { this.cashierName = cashierName; }

    public double getNetTotal() { return netTotal; }
    public void setNetTotal(double netTotal) { this.netTotal = netTotal; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getAmountTendered() { return amountTendered; }
    public void setAmountTendered(double amountTendered) { this.amountTendered = amountTendered; }

    public double getChangeDue() { return changeDue; }
    public void setChangeDue(double changeDue) { this.changeDue = changeDue; }

    public Timestamp getSaleDate() { return saleDate; }
    public void setSaleDate(Timestamp saleDate) { this.saleDate = saleDate; }
}