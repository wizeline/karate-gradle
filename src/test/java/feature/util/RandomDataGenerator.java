package feature.util;

import com.github.javafaker.Faker;

public class RandomDataGenerator {
    private static final Faker faker = new Faker();

    public static String randomContent() { return faker.lorem().sentence(); }
}
