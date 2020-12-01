import { LightningElement, track, api } from "lwc";
import getAccountDetails from "@salesforce/apex/LightningAccountSalesHistory.getAccountDetails";
import getSalesData from "@salesforce/apex/LightningAccountSalesHistory.getSalesData";
import getCurrentUserLocale from "@salesforce/apex/LightningAccountSalesHistory.getCurrentUserLocale";

import Sales_History_Revenue from '@salesforce/label/c.Sales_History_Revenue';
import Sales_History_Month_Stats from '@salesforce/label/c.Sales_History_Month_Stats';
import Sales_History_Quarter_Stats from '@salesforce/label/c.Sales_History_Quarter_Stats';
import Sales_History_Year_Stats from '@salesforce/label/c.Sales_History_Year_Stats';

import Sales_History_MTD_Diff from '@salesforce/label/c.Sales_History_MTD_Diff';
import Sales_History_MTD_LY from '@salesforce/label/c.Sales_History_MTD_LY';
import Sales_History_MTD_TY from '@salesforce/label/c.Sales_History_MTD_TY';
import Sales_History_Monthly_LY from '@salesforce/label/c.Sales_History_Monthly_LY';
import Sales_History_ADS_for_Current_Month from '@salesforce/label/c.Sales_History_ADS_for_Current_Month';
import Sales_History_AOV_for_Current_Month from '@salesforce/label/c.Sales_History_AOV_for_Current_Month';
import Sales_History_AOV_for_Last_Month from '@salesforce/label/c.Sales_History_AOV_for_Last_Month';
import Sales_History_ADS_for_Last_Month from '@salesforce/label/c.Sales_History_ADS_for_Last_Month';

import Sales_History_QTD_TY from '@salesforce/label/c.Sales_History_QTD_TY';
import Sales_History_QTD_LY from '@salesforce/label/c.Sales_History_QTD_LY';
import Sales_History_QTD_Diff from '@salesforce/label/c.Sales_History_QTD_Diff';
import Sales_History_Quarter_LY from '@salesforce/label/c.Sales_History_Quarter_LY';
import Sales_History_ADS_for_Last_Qtr from '@salesforce/label/c.Sales_History_ADS_for_Last_Qtr';
import Sales_History_ADS_for_Current_Qtr from '@salesforce/label/c.Sales_History_ADS_for_Current_Qtr';
import Sales_History_AOV_for_Current_Qtr from '@salesforce/label/c.Sales_History_AOV_for_Current_Qtr';
import Sales_History_AOV_for_Last_Qtr from '@salesforce/label/c.Sales_History_AOV_for_Last_Qtr';


import Sales_History_YTD_TY from '@salesforce/label/c.Sales_History_YTD_TY';
import Sales_History_YTD_LY from '@salesforce/label/c.Sales_History_YTD_LY';
import Sales_History_YTD_Diff from '@salesforce/label/c.Sales_History_YTD_Diff';
import Sales_History_Year_LY from '@salesforce/label/c.Sales_History_Year_LY';

import Sales_History_AOV_for_last_year from '@salesforce/label/c.Sales_History_AOV_for_last_year';
import Sales_History_AOV_for_current_year from '@salesforce/label/c.Sales_History_AOV_for_current_year';
import Sales_History_ADS_for_last_year from '@salesforce/label/c.Sales_History_ADS_for_last_year';
import Sales_History_ADS_for_current_year from '@salesforce/label/c.Sales_History_ADS_for_current_year';

import Sales_History_Customer_Creation_Date from '@salesforce/label/c.Sales_History_Customer_Creation_Date';
import Sales_History_Title from '@salesforce/label/c.Sales_History_Title';
import Sales_History_Indicator_Good from '@salesforce/label/c.Sales_History_Indicator_Good';
import Sales_History_Indicator_Bad from '@salesforce/label/c.Sales_History_Indicator_Bad';
import Sales_History_First_Order_Date from '@salesforce/label/c.Sales_History_First_Order_Date';
import Sales_History_Weeks_since_1st_Order from '@salesforce/label/c.Sales_History_Weeks_since_1st_Order';
import Sales_History_Weeks_since_Last_Order from '@salesforce/label/c.Sales_History_Weeks_since_Last_Order';
import Sales_History_Total_Orders from '@salesforce/label/c.Sales_History_Total_Orders';
import Sales_History_Last_Order_Date from '@salesforce/label/c.Sales_History_Last_Order_Date';
import Sales_History_Monthly_Sales from '@salesforce/label/c.Sales_History_Monthly_Sales';
import Sales_History_Weekly_Sales from '@salesforce/label/c.Sales_History_Weekly_Sales';
import Sales_History_Number_of_Orders from '@salesforce/label/c.Sales_History_Number_of_Orders';
import Sales_History_Predictive_Purchase from '@salesforce/label/c.Sales_History_Predictive_Purchase';
import Sales_History_Number_of_Orders_Since_Start from '@salesforce/label/c.Sales_History_Number_of_Orders_Since_Start';
import Sales_History_Number_of_Categories from '@salesforce/label/c.Sales_History_Number_of_Categories';
import Sales_History_Sales from '@salesforce/label/c.Sales_History_Sales';
import Sales_History_Number_of_Orders_Title from '@salesforce/label/c.Sales_History_Number_of_Orders_Title';
import Sales_History_Weekly_Sales_Title from '@salesforce/label/c.Sales_History_Weekly_Sales_Title';
import Sales_History_Monthly_Sales_Title from '@salesforce/label/c.Sales_History_Monthly_Sales_Title';
import Sales_History_Retention_Metrics_Title from '@salesforce/label/c.Sales_History_Retention_Metrics_Title';
import Sales_History_Conversion_Metrics_Title from '@salesforce/label/c.Sales_History_Conversion_Metrics_Title';
import Sales_History_Account_Details_Title from '@salesforce/label/c.Sales_History_Account_Details_Title';
import Sales_History_Currency_Code from '@salesforce/label/c.Sales_History_Currency_Code';
import Sales_History_AOV_for_Current_Yr from "@salesforce/label/c.Sales_History_AOV_for_Current_Yr";




export default class LwcSalesHistory extends LightningElement {
  @api recordId;
  @api objectApiName;
  @api show_metrics;
  @api show_account_details_metrics;
  @api show_account_retention_metrics;
  @api show_account_conversion_metrics;
  @api tab_name;
  @track currencyCode;
  @track error = false;
  @track errorMessage = "Error Message";
  @track revenueColumn = { label: Sales_History_Revenue, fieldName: "revenue", type: 'currency', typeAttributes: { currencyCode: this.currencyCode } };
  @track monthStats = {
    data: null,
    columns: [
    ]
  };
  @track quarterStats = {
    data: null,
    columns: [
    ]
  };
  @track yearStats = {
    data: null,
    columns: [
    ]
  };
  @track accountDetails = {};
  @track retentionMetrics = {};
  @track conversionMetrics = {};
  @track englishLabels = {
    accordionSectionName: 'Sales History',
    customerCreationDate: Sales_History_Customer_Creation_Date,
    firstOrderDate: Sales_History_First_Order_Date,
    weeksSinceFirstOrder: Sales_History_Weeks_since_1st_Order,
    weeksSinceLastOrder: Sales_History_Weeks_since_Last_Order,
    lastOrderDate: Sales_History_Last_Order_Date,
    totalOrders: Sales_History_Total_Orders,
    monthStats: Sales_History_Monthly_Sales,
    weeklySales: Sales_History_Weekly_Sales,
    numberOfOrders: Sales_History_Number_of_Orders,
    predictivePurchase: Sales_History_Predictive_Purchase,
    numberOfOrdersSinceStart: Sales_History_Number_of_Orders_Since_Start,
    numberOfCategories: Sales_History_Number_of_Categories,
    sales: Sales_History_Sales,
    title: Sales_History_Title,
    indicatorGood: Sales_History_Indicator_Good,
    indicatorBad: Sales_History_Indicator_Bad,
    numberOfOrders: Sales_History_Number_of_Orders_Title,
    retentionMetrics: Sales_History_Retention_Metrics_Title,
    accountDetails: Sales_History_Account_Details_Title,
    conversionMetrics: Sales_History_Conversion_Metrics_Title,
    monthStats: Sales_History_Month_Stats,
    quarterStats: Sales_History_Quarter_Stats,
    qtdTy: Sales_History_QTD_TY,
    qtdLy: Sales_History_QTD_LY,
    qtdDiff: Sales_History_QTD_Diff,
    quarterLy: Sales_History_Quarter_LY,
    adsForCurrentQuarter: Sales_History_ADS_for_Last_Qtr,
    adsForLastQtr: Sales_History_ADS_for_Last_Qtr,
    yearStats: Sales_History_Year_Stats,
    mtdTy: Sales_History_MTD_TY,
    mtdLy: Sales_History_MTD_LY,
    mtdDiff: Sales_History_MTD_Diff,
    monthlyLy: Sales_History_Monthly_LY,
    adsForCurrentMonth: Sales_History_ADS_for_Current_Month,
    adsForLastMonth: Sales_History_ADS_for_Last_Month,
    aovForCurrentMonth: Sales_History_AOV_for_Current_Month,
    aovForLastMonth: Sales_History_AOV_for_Last_Month,
    adsForCurrentQuarter: Sales_History_ADS_for_Current_Qtr,
    adsForLastQuarter: Sales_History_ADS_for_Last_Qtr,
    aovForCurrentQuarter: Sales_History_AOV_for_Current_Qtr,
    aovForLastQuarter: Sales_History_AOV_for_Last_Qtr,
    adsForCurrentYear: Sales_History_ADS_for_current_year,
    adsForLastYear: Sales_History_ADS_for_last_year,
    aovForCurrentYear: Sales_History_AOV_for_Current_Yr,
    aovForLastYear: Sales_History_AOV_for_last_year,
    yearStats: Sales_History_Year_Stats,
    ytdTy: Sales_History_YTD_TY,
    ytdLy: Sales_History_YTD_LY,
    ytdDiff: Sales_History_YTD_Diff,
    yearLy: Sales_History_Year_LY
  };
  @track frenchLabels = {
    accordionSectionName: 'Historique de ventes',
    customerCreationDate: 'Date de création du compte',
    firstOrderDate: 'Date de première commande',
    weeksSinceFirstOrder: 'Semaines depuis première commande',
    weeksSinceLastOrder: 'Semaines depuis dernière commande',
    lastOrderDate: 'Date de dernière commande',
    totalOrders: 'Commandes totales',
    monthStats: 'Ventes mensuelles',
    weeklySales: 'Ventes hebdomadaires',
    numberOfOrders: 'Nombre de commandes',
    predictivePurchase: 'Achats prévisionnels',
    numberOfOrdersSinceStart: 'Nombre de commandes depuis le début',
    numberOfCategories: 'Nombre de catégories',
    sales: 'Ventes',
    title: Sales_History_Title,
    indicatorGood: Sales_History_Indicator_Good,
    indicatorBad: Sales_History_Indicator_Bad,
    numberOfOrders: 'Nombre de commandes',
    retentionMetrics: 'Indicateurs de rétention',
    accountDetails: 'Détails du compte',
    conversionMetrics: 'Indicateurs de conversion',
    monthStats: 'Statistiques mensuelles',
    quarterStats: 'Stat. trim.',
    yearStats: 'Stat. ann',
    qtdTy: 'CUM trim. - ann. en cours',
    qtdLy: 'CUM trim. - ann. préc.',
    qtdDiff: 'Écart',
    quarterLy: 'Trim. – ann. préc.',
    adsForCurrentQuarter: 'ADS - trim. cour.',
    adsForLastQtr: 'ADS - trim. préc.',
    yearStats: 'Stat. ann',
    mtdTy: 'CUM mois - ann. en cours',
    mtdLy: 'CUM mois - ann. préc.',
    mtdDiff: 'Écart',
    monthlyLy: 'Mens. – ann. préc.',
    adsForCurrentMonth: 'ADS - mois courant',
    adsForLastMonth: 'ADS - mois précédent',
    aovForCurrentMonth: 'AOV - mois courant',
    aovForLastMonth: 'AOV - mois précédent',
    adsForCurrentQuarter: 'ADS - trim. cour.',
    adsForLastQuarter: 'ADS - trim. préc.',
    aovForCurrentQuarter: 'AOV - trim. courant',
    aovForLastQuarter: 'AOV - trim. préc.',
    adsForCurrentYear: 'ADS - année en cours',
    adsForLastYear: 'ADS - année précédente',
    aovForCurrentYear: 'AOV - année en cours',
    aovForLastYear: 'AOV - année précédente',
    yearStats: 'Stat. ann',
    ytdTy: 'CUM ann. - ann. en cours',
    ytdLy: 'CUM ann. - ann. préc.',
    ytdDiff: 'Écart',
    yearLy: 'Ann. – ann. préc.'
  };
  @track labels = {};
  get tabName() {
    return this.labels.accordionSectionName;
  }


  connectedCallback() {
    let salesDataComponent = this;

    getCurrentUserLocale()
      .then(response => {
        if (response == 'fr') {
          salesDataComponent.currencyCode = 'CAD';
          salesDataComponent.revenueColumn.typeAttributes.currencyCode = 'CAD';
          this.labels = this.frenchLabels;
        }
        else if (response == 'en_US') {
          salesDataComponent.currencyCode = 'USD';
          salesDataComponent.revenueColumn.typeAttributes.currencyCode = 'USD';
          this.labels = this.englishLabels;
        }

        this.monthStats.columns =
          [{ label: this.labels.monthStats, fieldName: "label", type: "text" },
          this.revenueColumn,
          { label: "IMU %", fieldName: "imu", type: "percent" }];
        this.quarterStats.columns = [
          { label: this.labels.quarterStats, fieldName: "label", type: "text" },
          this.revenueColumn,
          { label: "IMU %", fieldName: "imu", type: "percent" }];
        this.yearStats.columns = [
          { label: this.labels.yearStats, fieldName: "label", type: "text" },
          this.revenueColumn,
          { label: "IMU %", fieldName: "imu", type: "percent" }];

        getAccountDetails({ accountId: this.recordId })
          .then(response => {
            response = JSON.parse(response);
            // salesDataComponent.accountDetails.customerCreationDate = (response.Legacy_CreatedDate__c.includes("T") ? response.Legacy_CreatedDate__c.split("T")[0] : response.Legacy_CreatedDate__c)
            response.Legacy_CreatedDate__c;
            salesDataComponent.accountDetails.firstOrderDate =
              response.First_Order_Date__c;
            salesDataComponent.accountDetails.weeksSinceFirstOrder =
              response.Weeks_since_1st_Order_new__c;
            salesDataComponent.accountDetails.lastOrderDate =
              response.Last_Order_Date__c;
            salesDataComponent.accountDetails.weeksSinceLastOrder =
              response.Weeks_Since_Last_Order__c;
            salesDataComponent.accountDetails.weeks_since_last_order_new =
              response.Weeks_since_last_order_new__c;
            salesDataComponent.accountDetails.totalOrders = response.Total_Order__c;

            salesDataComponent.retentionMetrics.monthStats =
              response.Monthly_Sales__c === true;
            salesDataComponent.retentionMetrics.weeklySales =
              response.Weekly_Sales__c === true;
            salesDataComponent.retentionMetrics.numberOfOrders =
              response.Number_of_Orders__c === true;
            salesDataComponent.retentionMetrics.predictivePurchase =
              response.Predictive_Purchase__c === true;

            salesDataComponent.conversionMetrics.number_of_orders_check =
              response.Number_of_Orders_Check__c === true;
            salesDataComponent.conversionMetrics.has_number_of_categories =
              response.Number_of_Categories_Check__c === true;
            salesDataComponent.conversionMetrics.numberOfOrdersSinceStart =
              response.Num_of_Orders_Since_Start__c;
            salesDataComponent.conversionMetrics.numberOfCategories =
              response.Num_of_Categories__c;
            salesDataComponent.conversionMetrics.has_sales_check =
              response.Sales_Check__c === true;
            salesDataComponent.conversionMetrics.sales = this.formatCurrency(response.Sales__c);
          })
          .catch(error => {
            salesDataComponent.error = true;
          });

        getSalesData({ accountId: this.recordId })
          .then(response => {
            response = JSON.parse(response);

            console.log(JSON.stringify(response));

            salesDataComponent.monthStats.data = [
              {
                label: this.labels.mtdTy,
                revenue: parseFloat(response.MTD_Sales_TY__c).toFixed(0),
                imu: (response.MTD_Sales_TY__c === 0.0 ? 0.0 : response.MTD_Sales_TY_IMU__c / response.MTD_Sales_TY__c)
              },
              {
                label: this.labels.mtdLy,
                revenue: parseFloat(response.MTD_Sales_LY__c).toFixed(0),
                imu: (response.MTD_Sales_LY__c === 0.0 ? 0.0 : response.MTD_Sales_LY_IMU__c / response.MTD_Sales_LY__c)
              },
              {
                label: this.labels.mtdDiff,

                revenue: parseFloat(response.MTD_Sales_TY__c - response.MTD_Sales_LY__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.monthlyLy,
                revenue: parseFloat(response.Monthly_LY__c).toFixed(0),
                imu: (response.Monthly_LY__c === 0.0 ? 0.0 : response.MTD_Sales_LY_IMU__c / response.MTD_Sales_LY__c)
              },
              {
                label: this.labels.adsForCurrentMonth,
                revenue: parseFloat(response.ADS_Current_Month__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.adsForLastMonth,
                revenue: parseFloat(response.ADS_Last_Month__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForCurrentMonth,
                revenue: parseFloat(response.AOV_Current_Month__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForLastMonth,
                revenue: parseFloat(response.AOV_Last_Month__c).toFixed(0),
                imu: ""
              }
            ];
            salesDataComponent.quarterStats.data = [
              {
                label: this.labels.qtdTy,
                revenue: parseFloat(response.QTD_Sales_TY__c).toFixed(0),
                imu: (response.QTD_Sales_TY__c === 0.0 ? 0.0 : response.QTD_Sales_TY_IMU__c / response.QTD_Sales_TY__c)
              },
              {
                label: this.labels.qtdLy,
                revenue: parseFloat(response.QTD_Sales_LY__c).toFixed(0),
                imu: (response.QTD_Sales_LY__c === 0.0 ? 0.0 : response.QTD_Sales_LY_IMU__c / response.QTD_Sales_LY__c)
              },
              {
                label: this.labels.qtdDiff,
                revenue: parseFloat(response.QTD_Sales_TY__c - response.QTD_Sales_LY__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.quarterLy,
                revenue: parseFloat(response.Quarter_LY__c).toFixed(0),
                imu: (response.Quarterly_LY__c === 0.0 ? 0.0 : response.Quarter_LY_IMU__c / response.Quarter_LY__c)
              },
              {
                label: this.labels.adsForCurrentQuarter,
                revenue: parseFloat(response.ADS_Current_Qtr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.adsForLastQtr,
                revenue: parseFloat(response.ADS_Last_Qtr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForCurrentQuarter,
                revenue: parseFloat(response.AOV_Current_Qtr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForLastQuarter,
                revenue: parseFloat(response.AOV_Last_Qtr__c).toFixed(0),
                imu: ""
              }
            ];
            salesDataComponent.yearStats.data = [
              {
                label: this.labels.ytdTy,
                revenue: parseFloat(response.YTD_Sales_TY__c).toFixed(0),
                imu: (response.YTD_Sales_TY__c === 0.0 ? 0.0 : response.YTD_Sales_TY_IMU__c / response.YTD_Sales_TY__c)
              },
              {
                label: this.labels.ytdLy,
                revenue: parseFloat(response.YTD_Sales_LY__c).toFixed(0),
                imu: (response.YTD_Sales_LY__c === 0.0 ? 0.0 : response.YTD_Sales_LY_IMU__c / response.YTD_Sales_LY__c)
              },
              {
                label: this.labels.ytdDiff,
                revenue: parseFloat(response.YTD_Sales_TY__c - response.YTD_Sales_LY__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.yearLy,
                revenue: parseFloat(response.Year_LY__c).toFixed(0),
                imu: (response.Year_LY__c === 0.0 ? 0.0 : response.Year_LY_IMU__c / response.Year_LY__c)
              },
              {
                label: this.labels.adsForCurrentYear,
                revenue: parseFloat(response.ADS_Current_Yr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.adsForLastYear,
                revenue: parseFloat(response.ADS_Last_Yr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForCurrentYear,
                revenue: parseFloat(response.AOV_Current_Yr__c).toFixed(0),
                imu: ""
              },
              {
                label: this.labels.aovForLastYear,
                revenue: parseFloat(response.AOV_Last_Yr__c).toFixed(0),
                imu: ""
              }
            ];
          })
          .catch(error => {
            salesDataComponent.error = true;
            let errorMessage = error.body.message;
            salesDataComponent.errorMessage = String(errorMessage);
            console.error(JSON.stringify(errorMessage));
          });
      })
      .catch(error => {
        console.error(error);
      })

  }

  formatCurrency(value) {
    if (this.currencyCode === 'USD') {
      return new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD"
      }).format(value);
    } else if (this.currencyCOde === 'CAD') {
      return new Intl.NumberFormat("en-CA", {
        style: "currency",
        currency: "CAD"
      }).format(value);
    }
  }
}