import { LightningElement, track, api } from "lwc";
import getSalesData from "@salesforce/apex/AccountProductSalesData.getSalesData";
import getCurrentUserLocale from "@salesforce/apex/LightningAccountSalesHistory.getCurrentUserLocale";

import Product_Category_Snapshot_Miscellaneous from "@salesforce/label/c.Product_Category_Snapshot_Miscellaneous";
import Product_Category_Snapshot_MPS from "@salesforce/label/c.Product_Category_Snapshot_MPS";
import Product_Category_Snapshot_Office_Essentials from "@salesforce/label/c.Product_Category_Snapshot_Office_Essentials";
import Product_Category_Snapshot_Writing_Drafting from "@salesforce/label/c.Product_Category_Snapshot_Writing_Drafting";
import Product_Category_Snapshot_Labels_And_Forms from "@salesforce/label/c.Product_Category_Snapshot_Labels_And_Forms";
import Product_Category_Snapshot_Filing_And_Binding from "@salesforce/label/c.Product_Category_Snapshot_Filing_And_Binding";
import Product_Category_Snapshot_Tech from "@salesforce/label/c.Product_Category_Snapshot_Tech";
import Product_Category_Snapshot_CPD from "@salesforce/label/c.Product_Category_Snapshot_CPD";
import Product_Category_Snapshot_CBS from "@salesforce/label/c.Product_Category_Snapshot_CBS";
import Product_Category_Snapshot_Furniture from "@salesforce/label/c.Product_Category_Snapshot_Furniture";
import Product_Category_Snapshot_Ink_Toner from "@salesforce/label/c.Product_Category_Snapshot_Ink_Toner";
import Product_Category_Snapshot_Paper from "@salesforce/label/c.Product_Category_Snapshot_Paper";
import Product_Category_Snapshot_Title from "@salesforce/label/c.Product_Category_Snapshot_Title";
import Product_Category_Snapshot_TY_Sales_TD from "@salesforce/label/c.Product_Category_Snapshot_TY_Sales_TD";
import Product_Category_Snapshot_TY_Sales_IMU_Percent from "@salesforce/label/c.Product_Category_Snapshot_TY_Sales_IMU_Percent";
import Product_Category_Snapshot_LY_Sales_TD from "@salesforce/label/c.Product_Category_Snapshot_LY_Sales_TD";
import Product_Category_Snapshot_LY_IMU_Percent from "@salesforce/label/c.Product_Category_Snapshot_LY_IMU_Percent";
import Product_Category_Snapshot_Category from "@salesforce/label/c.Product_Category_Snapshot_Category";
import Product_Category_Snapshot_Sales_Difference from "@salesforce/label/c.Product_Category_Snapshot_Sales_Difference";
import Product_Category_Snapshot_Last_Order from "@salesforce/label/c.Product_Category_Snapshot_Last_Order";
import Product_Category_Snapshot_Last_Order_Amount from "@salesforce/label/c.Product_Category_Snapshot_Last_Order_Amount";
import Product_Category_Snapshot_Potential from "@salesforce/label/c.Product_Category_Snapshot_Potential";

export default class AccountProductSalesDataComp extends LightningElement {
  @api recordId;
  @api objectApiName;
  @api is_collapsible;
  @api is_collapsed;
  @api tab_name;
  @track active_section = "";
  @track error = false;
  @track englishLabels = {
    misc: Product_Category_Snapshot_Miscellaneous,
    mps: Product_Category_Snapshot_MPS,
    officeEssentials: Product_Category_Snapshot_Office_Essentials,
    writingDrafting: Product_Category_Snapshot_Writing_Drafting,
    labelsAndForms: Product_Category_Snapshot_Labels_And_Forms,
    filingAndBinding: Product_Category_Snapshot_Filing_And_Binding,
    tech: Product_Category_Snapshot_Tech,
    cpd: Product_Category_Snapshot_CPD,
    cbs: Product_Category_Snapshot_CBS,
    furniture: Product_Category_Snapshot_Furniture,
    inkToner: Product_Category_Snapshot_Ink_Toner,
    paper: Product_Category_Snapshot_Paper,
    title: Product_Category_Snapshot_Title,
    tySalesTd: Product_Category_Snapshot_TY_Sales_TD,
    tySalesImuPercent: Product_Category_Snapshot_TY_Sales_IMU_Percent,
    lySalesTd: Product_Category_Snapshot_LY_Sales_TD,
    lyImuPercent: Product_Category_Snapshot_LY_IMU_Percent,
    category: Product_Category_Snapshot_Category,
    salesDifference: Product_Category_Snapshot_Sales_Difference,
    lastOrder: Product_Category_Snapshot_Last_Order,
    lastOrderAmount: Product_Category_Snapshot_Last_Order_Amount,
    potential: Product_Category_Snapshot_Potential
  };
  @track frenchLabels = {
    misc: 'Divers',
    mps: Product_Category_Snapshot_MPS,
    officeEssentials: 'Produits essentiels de bureau',
    writingDrafting: 'Écriture et dessin',
    labelsAndForms: 'Étiquettes et formulaires',
    filingAndBinding: 'Classement et reliure',
    tech: 'Technologie',
    cpd: Product_Category_Snapshot_CPD,
    cbs: Product_Category_Snapshot_CBS,
    furniture: 'Mobilier',
    inkToner: Product_Category_Snapshot_Ink_Toner,
    paper: Product_Category_Snapshot_Paper,
    title: Product_Category_Snapshot_Title,
    tySalesTd: Product_Category_Snapshot_TY_Sales_TD,
    tySalesImuPercent: Product_Category_Snapshot_TY_Sales_IMU_Percent,
    lySalesTd: Product_Category_Snapshot_LY_Sales_TD,
    lyImuPercent: Product_Category_Snapshot_LY_IMU_Percent,
    category: Product_Category_Snapshot_Category,
    salesDifference: Product_Category_Snapshot_Sales_Difference,
    lastOrder: 'Date dern. comm.',
    lastOrderAmount: '$ dern. comm.',
    potential: 'Potentiel'
  };
  @track labels = {};
  @track columns = [
  ];
  @track data = [];

  getSalesDataEntry(
    category_label,
    ty_sales_td,
    ly_sales_td,
    imu_ty,
    imu_ly,
    last_order_date,
    last_order_amount
  ) {

    let obj = {
      category: category_label,
      ty_sales_td: parseFloat(ty_sales_td).toFixed(0),
      ty_imu_Percent: (ty_sales_td === 0.0 ? 0.0 : imu_ty / ty_sales_td),
      ly_sales_td: parseFloat(ly_sales_td).toFixed(0),
      ly_imu_percent: (ly_sales_td === 0.0 ? 0.0 : imu_ly / ly_sales_td),
      sales_diff: parseFloat(ty_sales_td - ly_sales_td).toFixed(0),
      last_order_date: last_order_date,
      last_order_amount: parseFloat(last_order_amount).toFixed(0),
      imu_ty: parseFloat(imu_ty).toFixed(0),
      imu_ly: parseFloat(imu_ly).toFixed(0),
    };

    console.log(JSON.stringify(obj));
    return obj;
  }

  connectedCallback() {
    getCurrentUserLocale()
      .then(response => {
        if (response == 'fr') {
          this.labels = this.frenchLabels;
        }
        else if (response == 'en_US') {
          this.labels = this.englishLabels;
        }
        this.columns = [
          {
            label: this.labels.category,
            fieldName: "category",
          },
          {
            label: this.labels.tySalesTd,
            fieldName: "ty_sales_td",
            type: "currency",
            cellAttributes: { alignment: "left" },
          },
          {
            label: this.labels.tySalesImuPercent,
            fieldName: "ty_imu_Percent",
            type: "percent",
            cellAttributes: { alignment: "left" },
          },
          {
            label: this.labels.lySalesTd,
            fieldName: "ly_sales_td",
            type: "currency",
            cellAttributes: { alignment: "left" },
          },
          {
            label: this.labels.lyImuPercent,
            fieldName: "ly_imu_percent",
            type: "percent",
            cellAttributes: { alignment: "left" },
          },
          {
            label: this.labels.salesDifference,
            fieldName: "sales_diff",
            type: "currency",
            cellAttributes: { alignment: "left" },
          },
          // Potential is being replaced.
          // {
          //   label: this.labels.potential,
          //   fieldName: "potential",
          //   type: "currency",
          //   cellAttributes: { alignment: "left" },
          // },
          {
            label: this.labels.lastOrder,
            fieldName: "last_order_date",
            type: "date",
            cellAttributes: { alignment: "left" },
          },
          {
            label: this.labels.lastOrderAmount,
            fieldName: "last_order_amount",
            type: "currency",
            cellAttributes: { alignment: "left" },
          },]
        let snapshot = this;

        if (this.is_collapsed) this.active_section = "Product_Category_Snapshot";
        getSalesData({ account_id: this.recordId })
          .then((response) => {
            console.log(JSON.stringify(response));
            let data = [
              this.getSalesDataEntry(
                this.labels.paper,
                response.Paper_TY__c,
                response.Paper_LY__c,
                response.Paper_IMU_TY__c,
                response.Paper_IMU_LY__c,
                response.PAPER_LAST_ORDER_DT_TXT__c,
                response.Paper_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.inkToner,
                response.Ink_Toner_TY__c,
                response.Ink_Toner_LY__c,
                response.Ink_Toner_IMU_TY__c,
                response.Ink_Toner_IMU_LY__c,
                response.INK_LAST_ORDER_DT_TXT__c,
                response.Ink_Toner_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.furniture,
                response.Furniture_TY__c,
                response.Furniture_LY__c,
                response.Furniture_IMU_TY__c,
                response.Furniture_IMU_LY__c,
                response.FURN_LAST_ORDER_DT_TXT__c,
                response.Furniture_last_order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.cbs,
                response.CBS_TY__c,
                response.CBS_LY__c,
                response.CBS_IMU_TY__c,
                response.CBS_IMU_LY__c,
                response.CBS_LAST_ORDER_DT_TXT__c,
                response.CBS_Last_order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.cpd,
                response.CPD_TY__c,
                response.CPD_LY__c,
                response.CPD_IMU_TY__c,
                response.CPD_IMU_LY__c,
                response.CPD_LAST_ORDER_DT_TXT__c,
                response.CPD_Last_order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.tech,
                response.Tech_TY__c,
                response.Tech_LY__c,
                response.Tech_IMU_TY__c,
                response.Tech_IMU_LY__c,
                response.TECH_LAST_ORDER_DT_TXT__c,
                response.Tech_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.filingAndBinding,
                response.Filing_Binding_TY__c,
                response.Filing_Binding_LY__c,
                response.Filing_Binding_IMU_TY__c,
                response.Filing_Binding_IMU_LY__c,
                response.FILING_LAST_ORDER_DT_TXT__c,
                response.Filing_Binding_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.labelsAndForms,
                response.Labels_Forms_TY__c,
                response.Labels_Forms_LY__c,
                response.Labels_Forms_IMU_TY__c,
                response.Labels_Forms_IMU_LY__c,
                response.LABELS_LAST_ORDER_DT_TXT__c,
                response.Labels_Forms_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.writingDrafting,
                response.Writing_Drafting_TY__c,
                response.Writing_Drafting_LY__c,
                response.Writing_Drafting_IMU_TY__c,
                response.Writing_Drafting_IMU_LY__c,
                response.WRITING_LAST_ORDER_DT_TXT__c,
                response.Writing_Drafting_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.officeEssentials,
                response.Office_Essentials_TY__c,
                response.Office_Essentials_LY__c,
                response.Office_Essentials_IMU_TY__c,
                response.Office_Essentials_IMU_LY__c,
                response.OFFICE_LAST_ORDER_DT_TXT__c,
                response.Office_Essentials_Last_Order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.mps,
                response.MPS_TY__c,
                response.MPS_LY__c,
                response.MPS_IMU_TY__c,
                response.MPS_IMU_LY__c,
                response.MPS_LAST_ORDER_DT_TXT__c,
                response.MPS_Last_order_amt__c
              ),
              snapshot.getSalesDataEntry(
                this.labels.misc,
                response.Miscellaneous_TY__c,
                response.Miscellaneous_LY__c,
                response.Miscellaneous_IMU_TY__c,
                response.Miscellaneous_IMU_LY__c,
                response.MISC_LAST_ORDER_DT_TXT__c,
                response.Miscellaneous_Last_Order_amt__c
              ),
            ];

            console.log(JSON.stringify(snapshot.data));

            let total_ty_sales_td_sum = data.reduce(function (
              accumulator,
              currentValue,
              currentIndex,
              array
            ) {
              return accumulator + parseFloat(currentValue.ty_sales_td);
            },
              0);

            let total_ly_sales_td_sum = data.reduce(function (
              accumulator,
              currentValue,
              currentIndex,
              array
            ) {
              return accumulator + parseFloat(currentValue.ly_sales_td);
            },
              0);

            let total_ty_imu_sum = data.reduce(function (
              accumulator,
              currentValue,
              currentIndex,
              array
            ) {
              return accumulator + parseFloat(currentValue.imu_ty);
            },
              0);

            let total_ly_imu_sum = data.reduce(function (
              accumulator,
              currentValue,
              currentIndex,
              array
            ) {
              return accumulator + parseFloat(currentValue.imu_ly);
            },
              0);


            let sales_difference_sum = data.reduce(function (
              accumulator,
              currentValue,
              currentIndex,
              array
            ) {
              return accumulator + parseFloat(currentValue.sales_diff);
            },
              0);
            console.log(
              total_ty_sales_td_sum,
              total_ly_sales_td_sum,
              total_ty_imu_sum,
              total_ly_imu_sum
            );
            data.push({
              category: "Total",
              ty_sales_td: total_ty_sales_td_sum,
              ty_imu_Percent:
                parseInt(total_ty_sales_td_sum) === 0
                  ? 0.0
                  : total_ty_imu_sum / total_ty_sales_td_sum,
              ly_sales_td: total_ly_sales_td_sum,
              ly_imu_percent:
                parseInt(total_ly_sales_td_sum) === 0
                  ? 0.0
                  : total_ly_imu_sum / total_ly_sales_td_sum,
              sales_diff: sales_difference_sum,
              last_order_date: "--",
              last_order_amount: "--",
              //potential: total_potential,
            });

            snapshot.data = data;
          })
          .catch((error) => {
            snapshot.error = true;
            console.error(JSON.stringify(error));
          });
      })
      .catch(error => {
        console.error(error);
      })


  }

  get_ty_total(total, product_category_data) {
    return total + product_category_data.ty_sales_td;
  }
}