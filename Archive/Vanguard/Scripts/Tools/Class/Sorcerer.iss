
variable bool SorcRunOnce = TRUE
variable int NextSorcCheck = ${Script.RunningTime}
variable int NextSorcLocCheck = ${Script.RunningTime}
variable point3f SorcLocation = ${Me.Location}
function Sorcerer()
{
	;; return if your class is not a Bard
	if !${Me.Class.Equal[Sorcerer]}
		return

		;; forces this only to run once every .2 seconds
	if ${Math.Calc[${Math.Calc[${Script.RunningTime}-${NextSorcCheck}]}/100]}<2
	{
		return
	}
	NextSorcCheck:Set[${Script.RunningTime}]

	;; we only want to run this once
	if ${SorcRunOnce}
	{
		;; show the Bard tab in UI
		UIElement[Sorcerer@Class@DPS@Tools]:Show
		
		; Calculate Highest Level
		declare "Incinerate" string local "Incinerate"
		declare "Mimic" string local "Mimic"
		SorcRunOnce:Set[FALSE]
	}
	
	;; use any crits
	call SorcCrits
	
	
	if ${Math.Distance[${Me.Location},${SorcLocation}]}>25
	{
		NextSorcLocCheck:Set[${Script.RunningTime}]
		SorcLocation:Set[${Me.Location}]
	}
	if ${Math.Calc[${Math.Calc[${Script.RunningTime}-${NextSorcLocCheck}]}/1000]}>4
	{
		if !${Me.InCombat} && ${Me.Ability[Gather Energy].IsReady} && ${Me.EnergyPct}<=40
		{
			vgecho "Gathering Energy"
			call UseAbility "Gather Energy"
			wait 180
			return
		}
	}

	;if ${Me.Target(exists)} && !${Me.InCombat} && ${Me.Target.Distance}<25 && ${Me.EnergyPct}>=20 && ${Me.TargetHealth}<=${StartAttack}
	;{
	;	call UseAbilities
	;}
}	
	
	
	
;===================================================
;===       CRIT/FINISH SUB-ROUTINE              ====
;===================================================
function SorcCrits()
{
	;; return if no crits
	if ${Me.Ability[${Incinerate}].TriggeredCountdown}==0 && ${Me.Ability[${Mimic}].TriggeredCountdown}==0
	{
		return
	}
	

	;; FIRE CRIT
	call OkayToAttack "${Incinerate}"
	if ${Return} &&	${Me.Ability[${Incinerate}].IsReady} && ${Me.Ability[${Incinerate}].TimeRemaining}==0
	{
		Me.Ability[${Incinerate}]:Use
		call GlobalCooldown
	}

	;; ARCANE CRIT
	call OkayToAttack "${Mimic}"
	if ${Return} && ${Me.Ability[${Mimic}].IsReady} && ${Me.Ability[${Mimic}].TimeRemaining}==0
	{
		Me.Ability[${Mimic}]:Use
		call GlobalCooldown
	}
}
	
