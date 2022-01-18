// Add the missing params or copy this.
class NovConfig {
	/* Params for Taxes */
	nov_useLivretA = 1; // Enable the usage of Livret A by Novax in the calculus (0 for disabled; 1 for enabled)
	nov_useFactionBank = 0; // Enable the usage of faction bank by Novax to redistribute money to factions (0 for disabled, 1 for enabled)
	nov_cashAmmountSteps[] = {0,100000,200000,300000,400000,1000000}; // Used to do intervals to define in which percent the player is
	nov_percentAmmountPerSteps[] = {0,0.5,0.75,1,2,3}; // Percents used for taxes, number of elements must be identical to numbers in nov_cashAmmountSteps
												  // Only works with integers
											      // Here if you have between 0$ and 100.000$ you will have 0% taxes.
											      // If you have between 400.000$ and 1.000.000$ you will be taxed 10%.
												  // If you have more than 1.000.000$ you will be taxed 15%.
	nov_timeBeforeTaxes = 0.5; // Time in minutes
};