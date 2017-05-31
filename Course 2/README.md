# Course2
Coursera iOS Specialization - Course 2

Part 1 Implement Filter and Compare functions

- [X] 1. When a user taps a filter button, the image view should update with the filtered image.

  Use the RGBAImage class from the course 1 project to get access to the pixels contained in a UIImage object.
  Employ your filter code from course 1 to filter the selected image.

- [X] 2. When a user taps the compare button, the image view should show the original image. When they tap the button again, show the filtered image.

Part 2 Refine the UI

- [X] 1. Disable the compare button when a filter hasn’t been selected.

  If the user hasn’t selected a filter yet, then the image hasn’t changed, and the compare button isn’t useful. Disable the button when its function is not needed.

- [X] 2. Make it easier to compare the original and filtered images.

  When the user touches the image, toggle between the filtered, and original images temporarily.
  When the user lifts their finger, toggle back.

- [X] 3. Make it more explicit that the user is looking at the original image.

  Add a small overlay view on top of the image view with the text “Original”. This should only be visible when the user is looking at the original image.

- [X] 4. Cross-fade images when a user selects a new filter or uses the compare function.

  A smoother transition between images gives the app a more refined feel.
  During the cross-fade you will need to display two images at once. You’ll need to add a second UIImageView on top of the first one, and you can animate the alpha of the top view to show or hide the bottom view.

- [X] 5. Use images instead of text for the filter buttons.

  Choose a small generic image that you can use as an icon for the filter buttons.
  For each filter button, replace the text with a filtered version of that icon so that the user can see what the effect looks like before they select it.
  You may not be able to fit as many filter buttons on the screen if you use images, that’s ok, just fit as many as you can.

- [X] 6. Add an Edit button.

  Add an edit button next to the Filter button in the bottom toolbar. The function of this button is to allow the user to adjust the intensity of the currently applied filter (this button should be disabled until a filter has been selected.)
  When the user taps the edit button, hide the filter option list (if visible) and show a UISlider widget instead.
  After the user adjusts the slider, the image should be updated with the new filter intensity.

- [X] Part 3 Optional Bonus Challenge – UICollectionView
