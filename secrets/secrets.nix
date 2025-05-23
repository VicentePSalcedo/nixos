let
  sintra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/nPpmlCKoUeKCcNsrB7QflhrYfYgY4cjobAysn9FS7 vicentepsalcedo@gmail.com";
  users = [ sintra ];

  wraith = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCZU/6i3ggAbOy32tATnmn9MuxV1ArBW9JD4tgd1NHXMARYlMqbdtR2ydLBzjCZQ5I9L3MKDyKXkxQcIfB9CqYS+936oTEexzmmCyWk29W0EbsgN25rVEFSkqmQ8WeIgI92jIYHAtH/AAft5iFroQGFE6+9TNreglCFO5sMuzKVlvwAw9cmxf42n7/JmAzrtKm/aI8cjSXN5cMvjg1857PrtIgVhf1gOHBrmWVrEoI+P+zkABL033KDPSkmMX+hCwYjqW+XKwHHSOXPLi+B6mzgxQ24i4e4/N0xjQd4C/MN+BUplOT4/rms+FPSavsN9mlFgbgaM6WQM7MnZ2u13Q+zJkWdEUxb3v5rghPGSOToHMnmKkeyKT8vOoy73s2IrCU94IrTOnM22g/hxW3t7nuhfuAgn2h5smHjZ03RQLyUfGUjm3oZa2J99fsz0sU5MnvrEaG9a6m/wnDPfUnsr2XvxEkODwbP7JI31lRldRVjXIBjfmnU2/8YhC14vylbJXrvYZhBMFWhkq2KzEllsirzoRY6SivVQKYijhWdVznYHgfYfNP+kepnSTJDf0RfuR8SyAI3TTXDEY0/jAhPRkfTJiQLiNGDm4c3XhEy15Sn/qJs+uI8c4wCq4n9anCuBdUsECDvUuG4NNGS0lw6F7SrQkFDsq2qR7l7lU5R4LF45w== root@pipboy3000";
  systems = [ wraith ];
in
{
  "codex_gemini_key.age".publicKeys = [
    sintra
    wraith
  ];
}
