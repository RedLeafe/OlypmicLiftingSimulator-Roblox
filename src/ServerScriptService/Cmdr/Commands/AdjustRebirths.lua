return {
	Name = "adjustPlayerRebirths";
	Aliases = {"aPR"};
	Description = "Adjust Player's Rebirths";
	Group = "Admin"; 
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The Player"
			
		},
		{
			Type = "number";
			Name = "Amount of Rebirths";
			Description = "The amount of Rebirths to add or substract from the Player"
			
		},
		
	}
	
}