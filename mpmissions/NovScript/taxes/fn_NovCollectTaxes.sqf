#include "..\..\script_macros.hpp"
/*
    File: fn_NovCollectTaxes.sqf
    Author: Novax
	github : https://github.com/Novax69 <== Find my other scripts for arma here
	Date : 18/01/2022

    Description: 
		Collect taxes from Bank Account + Livret A (if used)

*/

private["_capital","_useLivretA","_useFactionBank","_cashStepArray","_percentStepArray","_countArray","_low","_high","_percentUsed","_valueTaxed","_ammountForFac","_timeBeforeTaxes"];

_useLivretA = NOV_PARAMS(getNumber,"nov_useLivretA");
_useFactionBank = NOV_PARAMS(getNumber,"nov_useFactionBank");
_cashStepArray = NOV_PARAMS(getArray,"nov_cashAmmountSteps");
_percentStepArray = NOV_PARAMS(getArray,"nov_percentAmmountPerSteps");
_timeBeforeTaxes = round(NOV_PARAMS(getNumber,"nov_timeBeforeTaxes")*60); // Convert in minutes
_countArray = count _cashStepArray;


// If it's not the same it would not work properly.
if(_countArray != count _percentStepArray) exitWith {
	hint "Erreur lors de l'initialisation des taxes, veuillez signaler le problème à un administrateur";
	diag_log "----------------- NOVAX SCRIPT ERROR -----------------";
	diag_log format ["file => /NovScript/Taxes/NovCollectTaxes.sqf"];
	diag_log format ["Error => _cashStepArray size (%1) != _percentStepArray size (%2)",count _cashStepArray, count _percentStepArray];
	diag_log format ["Fix => Verify in Config_Nov.hpp that nov_cashAmmountSteps and nov_percentAmmountPerSteps have the same number of values"];
	diag_log "----------------- NOVAX SCRIPT ERROR -----------------";
};

while { true } do {
	sleep _timeBeforeTaxes;
	_capital = BANK;
	if(_useLivretA isEqualTo 1) then { _capital = _capital + LIVREA; }; // Ajout du capital livret A

	for [{private _i = 1}, {_i <= _countArray}, {_i = _i + 1}] do {
		if(_i isEqualTo _countArray) then {
			if(_capital > _cashStepArray select _i-1) exitWith {  
				_percentUsed = _percentStepArray select _i-1;
				if (_percentUsed != 0) then { 
					_valueTaxed = round((_capital * _percentUsed)/100);
					if(BANK - _valueTaxed < 0) then {
						BANK = 0;
					} else { BANK = BANK - _valueTaxed;	};
					if (BANK < 0) then { BANK = 0 };
 				};

				if(_useFactionBank isEqualTo 1 && _valueTaxed != 0) then {
					_ammountForFac = round(_valueTaxed / 2);
					// Ajout cash independant
					INDEBANK = INDEBANK + _ammountForFac;
					// Ajout cash blufor
					BLUBANK = BLUBANK + _ammountForFac;
				};
			};
		} else {
			if(_capital > (_cashStepArray select _i-1) && (_capital < (_cashStepArray select _i))) exitWith {
				_percentUsed = _percentStepArray select _i-1;
				_valueTaxed = round((_capital * _percentUsed)/100);
				if(_valueTaxed != 0) then { 
					if(BANK - _valueTaxed < 0) then {
						BANK = 0;
					} else { BANK = BANK - _valueTaxed; };
					if(_useFactionBank isEqualTo 1 && _valueTaxed != 0) then {
						_ammountForFac = round(_valueTaxed / 2);
						// Ajout cash independant
						INDEBANK = INDEBANK + _ammountForFac;
						// Ajout cash blufor
						BLUBANK = BLUBANK + _ammountForFac;					
					};
				};
			};
		};
	};

	if(_valueTaxed isEqualTo 0) then {
		["NovInfoMessage",[localize "STR_NOV_Taxes_InfoNotif","NovScript\NovTextures\Taxes.paa",localize "STR_NOV_Taxes_NoTaxes"]] call BIS_fnc_showNotification;
	} else {
		["NovInfoMessage",[localize "STR_NOV_Taxes_InfoNotif","NovScript\NovTextures\Taxes.paa", format[(localize "STR_NOV_Taxes_YouGotTaxed"),[_percentUsed] call life_fnc_numberText,'%',[_valueTaxed] call life_fnc_numberText]]] call BIS_fnc_showNotification;
	};
	[6] call SOCK_fnc_updatePartial; 
	if(_useFactionBank isEqualTo 1) then {
		// Fonctions de MAJ des banques de factions
	};
};
