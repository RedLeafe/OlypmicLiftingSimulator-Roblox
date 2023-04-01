return {
	Name = "getPlayerData";
	Aliases = { "getData", "gpd"};
	Description = "Prints the Player's data of a specific directory.";
	Group = "Admin";
	Args= {
		{
			Type = "player";
			Name = "Player";
			Description = "The Player";
			Optional = true;
		},
		{
			Type = "dataDirectory";
			Name = "Data Directory";
			Description = "The directory of data you want to get of a Player";
			Optional = true;
		}
	}
}