public class SelectAnimals{

	public List<Info> info;

	public class Info {
		public String Name;
		public String Eats;
		public String Says;
		public Integer ExternalId;
	}

	
	public static SelectAnimals parse(String json) {
		return (SelectAnimals) System.JSON.deserialize(json, SelectAnimals.class);
	}
}