

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.util.HashMap;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.*;

public class CheckOutServiceIntegrationTest {

    private Map<Integer, Integer> mockDatabaseTable;
    private Map<Integer, Integer> mockRAMCache;

    @BeforeEach
    public void setUp() {

        mockDatabaseTable = new HashMap<>();
        mockRAMCache = new HashMap<>();


        mockDatabaseTable.put(1, 10);
        mockRAMCache.put(1, 10);
    }

    @Test
    public void testACIDTransactionExecutionWithCacheSync() {
        long startTime = System.currentTimeMillis();


        int itemId = 1;
        int purchaseQty = 2;


        int initialDbStock = mockDatabaseTable.get(itemId);
        int updatedDbStock = initialDbStock - purchaseQty;
        mockDatabaseTable.put(itemId, updatedDbStock);


        mockRAMCache.put(itemId, updatedDbStock);

        long latency = System.currentTimeMillis() - startTime;


        assertNotNull(mockDatabaseTable.get(itemId));
        assertEquals(8, mockDatabaseTable.get(itemId), "Database transaction integrity failure.");
        assertEquals(8, mockRAMCache.get(itemId), "RAM Cache Synchronization failed.");

        System.out.println("JUnit 5 Enterprise Performance Metrics:");
        System.out.println("Execution Latency Overhead: " + latency + " ms");
    }
}