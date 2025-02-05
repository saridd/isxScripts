variable int TotalHarvest = ${Script[BM1].VariableScope.TotalHarvest}

variable int QJ = 0
variable int VIT = 0
variable int FRENZY = 0
variable int VialOfBlood = 0
variable int TwitchingMuscle = 0
variable int QuiveringBrain = 0
variable int StillBeatingheart = 0

function main()
{
	call StartRoutine ${TotalHarvest}
}


function UpdateInventoryCount()
{
	QJ:Set[0]
	VIT:Set[0]
	FRENZY:Set[0]
	VialOfBlood:Set[0]
	TwitchingMuscle:Set[0]
	QuiveringBrain:Set[0]
	StillBeatingheart:Set[0]

	;; total items in inventory
	variable int TotalItems = 0
	
	;; define our index
	variable index:item CurentItems
	
	;; populate our index and update total items in inventory
	TotalItems:Set[${Me.GetInventory[CurentItems]}]

	;; total quantity counter
	variable int TotalQuantity = 0

	;; counter
	variable int i = 0
	
	;; loop through all items
	for (i:Set[1] ; ${i}<=${TotalItems} ; i:Inc)
	{
		if ${CurentItems.Get[${i}].Name.Find[Quickening Symbiote]}
		{
			QJ:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Vitalizing Symbiote]}
		{
			VIT:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Frenzied Symbiote]}
		{
			FRENZY:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Vial of Blood]}
		{
			VialOfBlood:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Twitching Muscle]}
		{
			TwitchingMuscle:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Quivering Brain]}
		{
			QuiveringBrain:Inc[${CurentItems.Get[${i}].Quantity}]
		}
		elseif ${CurentItems.Get[${i}].Name.Find[Still Beating Heart]}
		{
			StillBeatingheart:Inc[${CurentItems.Get[${i}].Quantity}]
		}
	}
}		



function StartRoutine(int Symbiotes=5)
{
	call UpdateInventoryCount
	
	if !${Me.Ability[Grim Harvest](exists)}
	{
		return
	}

	Pawn[ExactName,Sacrificial Beast]:Target
	wait 3
	
	Pawn[ExactName,Great Statue of Arakorr]:Target
	wait 3
	
	if !${Me.Target.Name.Equal[Sacrificial Beast]} && !${Me.Target.Name.Equal[Great statue of Arakorr]}
	{
		return
	}
	
	face "${Me.Target.Name}"

	;; Loop this endef
	while 1
	{
		if (!${Me.Target.Name.Equal[Sacrificial Beast]} && !${Me.Target.Name.Equal[Great statue of Arakorr]}) || ${Me.Target.IsDead} || ${Me.Target.Type.Equal[Corpse]}
		{
			return
		}
	
		;; Catch till ready
		call GetReady

		;; Start our harvesting
		if (${Me.Target.Name.Equal[Sacrificial Beast]} || ${Me.Target.Name.Equal[Great statue of Arakorr]}) && ${Me.TargetHealth}>0
		{
			;; Cast appropriate ability
			call Harvest ${Symbiotes}
			
			;; Check for loot
			call Loot
		}
	}
}

function Harvest(int Symbiotes)
{
	if !${Me.CurrentForm.Name.Equal[Sanguine Focus]}
	{
		Me.Form[Sanguine Focus]:ChangeTo
		wait 25 
	}

	if  ${Me.Ability[Grim Harvest].TimeRemaining}>2
	{
		return
	}

	call UpdateInventoryCount

	; Blood Vials
	if ${VialOfBlood}<${Symbiotes} && ${Me.HealthPct}>=90
	{
		if ${Me.Ability[Siphon Blood](exists)}
		{
			Me.Ability[Siphon Blood]:Use
			wait 5
			Pawn[me]:Target
			call GetReady
			
			Pawn[me]:Target
			if ${Me.Ability[${TransfusionOfSerak}].IsReady}
			{
				Me.Ability[${TransfusionOfSerak}]:Use
				wait 5
				call GetReady
			}
			return
		}
	}
	
	;; Twitching Muscle
	if ${TwitchingMuscle}<${Symbiotes}
	{
		if ${Me.Ability[${Constrict}](exists)}
		{
			Me.Ability[${Constrict}]:Use
			wait 5
			call GetReady
				
			Me.Ability[Grim Harvest]:Use
			wait 5
			call GetReady
			return
		}
	}
	
	;; Quivering Brain
	if ${QuiveringBrain}<${Symbiotes}
	{
		if ${Me.Ability[Bursting Cyst I](exists)}
		{
			Me.Ability[Bursting Cyst I]:Use
			wait 5
			call GetReady
				
			Me.Ability[Grim Harvest]:Use
			wait 5
			call GetReady
			return
		}
	}
	
	;; Still Beating Heart
	if ${StillBeatingheart}<${Symbiotes}
	{
		if ${Me.Ability[Union of Blood I](exists)}
		{
			Me.Ability[Union of Blood I]:Use
			wait 5
			call GetReady
				
			Me.Ability[Grim Harvest]:Use
			wait 5
			call GetReady
			return
		}
	}
	
	;; Pulsating Stomach
	if ${Me.Inventory[Pulsating Stomach].Quantity}<${Symbiotes}
	{
		if ${Me.Ability[Blood Letting Ritual I](exists)}
		{
			Me.Ability[Blood Letting Ritual I]:Use
			wait 5
			call GetReady
				
			Me.Ability[Grim Harvest]:Use
			wait 5
			call GetReady
			return
		}
	}
}

function atexit()
{
	call UpdateInventoryCount
	vgecho "----------"
	vgecho QJ=${QJ}
	vgecho VIT=${VIT}
	vgecho FRENZY=${FRENZY}
	vgecho VialOfBlood=${VialOfBlood}
	vgecho TwitchingMuscle=${TwitchingMuscle}
	vgecho QuiveringBrain=${QuiveringBrain}
	vgecho StillBeatingheart=${StillBeatingheart}
}


function Loot()
{
	wait 10 ${Me.IsLooting}
	;; Quick, loot the target
	if ${Me.IsLooting}
	{
		Loot:LootAll
		wait 5
		if ${Me.IsLooting}
		{
			Loot:EndLooting
			wait 5
		}
	}
}

objectdef Obj_Commands
{
	;; identify the Passive Ability
	variable string PassiveAbility = "Racial Inheritance:"
	variable int TankGN

	;; initialize when objectdef is created
	method Initialize()
	{
		variable int i
		for (i:Set[1] ; ${Me.Ability[${i}](exists)} ; i:Inc)
		{
			if ${Me.Ability[${i}].Name.Find[Racial Inheritance:]}
				This.PassiveAbility:Set[${Me.Ability[${i}].Name}]
		}
	}

	;; called when script is shut down
	method Shutdown()
	{
	}

	;; external command
	member:bool AreWeReady()
	{
		if ${Me.Ability[${This.PassiveAbility}].IsReady}
			return TRUE
		return FALSE
	}
	
	member:bool AreWeEating()
	{
		variable int i
		for (i:Set[1]; ${Me.Effect[${i}](exists)}; i:Inc)
		{
			if ${Me.Effect[${i}].IsBeneficial}
			{
				if ${Me.Effect[${i}].Description.Find[Health:]} && ${Me.Effect[${i}].Description.Find[Energy:]} && ${Me.Effect[${i}].Description.Find[over]} && ${Me.Effect[${i}].Description.Find[seconds]}
					return TRUE
			}
		}
		return FALSE
	}
	

}
variable(global) Obj_Commands SYMBIOTES

function GetReady()
{
	if ${VG.InGlobalRecovery} || !${SYMBIOTES.AreWeReady}
	{
		while ${VG.InGlobalRecovery} || !${SYMBIOTES.AreWeReady}
		{
			waitframe
		}
		wait 3
	}
}
