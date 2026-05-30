package com.smartpos.model;

public class SaleItem {
    private int productId;
    private int quantity;
    private double unitPrice;
    private double itemSubtotal;

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getItemSubtotal() { return itemSubtotal; }
    public void setItemSubtotal(double itemSubtotal) { this.itemSubtotal = itemSubtotal; }
}