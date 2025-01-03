document.addEventListener("DOMContentLoaded", () => {
    const parentEventForm = document.getElementById("parent-event-form");
    const addChildEventBtn = document.getElementById("add-child-event");
    const childEventsContainer = document.getElementById("child-events-container");

    let childEvents = [];

    // Add Child Event
    addChildEventBtn.addEventListener("click", () => {
        const childEventName = document.getElementById("child-event-name").value;
        const childEventType = document.getElementById("child-event-type").value;
        const maxParticipants = document.getElementById("max-participants").value;
        const childEventDescription = document.getElementById("child-event-description").value;

        if (childEventName && childEventType && maxParticipants) {
            // Create child event object
            const childEvent = {
                childEventName,
                childEventType,
                maxParticipants: parseInt(maxParticipants),
                childEventDescription
            };

            // Add to array and clear the form
            childEvents.push(childEvent);
            clearChildEventForm();

            // Add badge to UI
            const badge = document.createElement("div");
            badge.classList.add("badge");
            badge.textContent = childEventName;
            childEventsContainer.appendChild(badge);

            badge.addEventListener("click", () => {
                populateChildEventForm(childEvent);
            });
        } else {
            alert("Please fill in all required fields for the child event!");
        }
    });

    // Submit Parent Event Form
    parentEventForm.addEventListener("submit", (e) => {
        e.preventDefault();

        const parentEvent = {
            eventName: document.getElementById("event-name").value,
            eventType: document.getElementById("event-type").value,
            eventDate: document.getElementById("event-date").value,
            eventDescription: document.getElementById("event-description").value,
            childEvents
        };

        // POST request to backend
        fetch("http://localhost:8050/organiser/newEvent", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(parentEvent)
        })
        .then(response => response.json())
        .then(data => {
            alert("Event created successfully!");
            parentEventForm.reset();
            childEventsContainer.innerHTML = "";
            childEvents = [];
        })
        .catch(error => {
            console.error("Error:", error);
            alert("An error occurred while creating the event.");
        });
    });

    // Clear Child Event Form
    function clearChildEventForm() {
        document.getElementById("child-event-name").value = "";
        document.getElementById("child-event-type").value = "";
        document.getElementById("max-participants").value = "";
        document.getElementById("child-event-description").value = "";
    }

    // Populate Child Event Form for Editing (optional feature)
    function populateChildEventForm(childEvent) {
        document.getElementById("child-event-name").value = childEvent.childEventName;
        document.getElementById("child-event-type").value = childEvent.childEventType;
        document.getElementById("max-participants").value = childEvent.maxParticipants;
        document.getElementById("child-event-description").value = childEvent.childEventDescription;
    }
});
