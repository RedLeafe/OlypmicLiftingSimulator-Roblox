return {
	Name = "adjustPlayerStrength";
	Aliases = {"aPS"};
	Description = "Adjust Player's Strength";
	Group = "Admin"; 
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The Player"
			
		},
		{
			Type = "number";
			Name = "Amount of Strength";
			Description = "The amount of Strength to add or substract from the Player"
			
		},
		
	}
	
}