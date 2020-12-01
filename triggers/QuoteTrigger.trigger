/*created by:shravya channamadhavuni
 * Purpose: Tech Sales project 
 * Functionality : Add price book id and billing address, shipping address
 * */
trigger QuoteTrigger on Quote (before insert, before update, after insert,after update){
new QuoteTriggerHelper().run();
}