return {
    Name = "givePet";
    Aliases = { "gP" };
    Description = "gives player a pet";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "Player to give pet to";
        },
        {
            Type = "pet";
            Name = "Pet";
            Description = "The specified pet to give";
        },


    }

}