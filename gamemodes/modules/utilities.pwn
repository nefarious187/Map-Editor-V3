CreateRandomString(destination[], length = sizeof destination)
{
	new bool:useCaps = false;

	while (length--)
	{
		useCaps = bool:random(2);

		destination[length] = (useCaps) ? RandomRange('A', 'Z') : RandomRange('a', 'z');
	}
}

RandomRange(min, max)
{
	return random(max - min) + min;
}

SetRandomPassword()
{
	new serverPassword[20];

	CreateRandomString(serverPassword, 10);
	strins(serverPassword, "password ", 0);

	SendRconCommand(serverPassword);
}
