Feature: Sidebar Sections

  Creating and Configuring sidebar sections

  Background:
    Given I am logged in
    And a post with the title "Hello World" exists

  Scenario: Create a sidebar for all actions
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should see a sidebar titled "Help"
    Then I should see /Need help/ within the sidebar "Help"

    When I follow "View"
    Then I should see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see a sidebar titled "Help"


  Scenario: Create a sidebar for only one action
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help, :only => :index do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should see a sidebar titled "Help"
    Then I should see /Need help/ within the sidebar "Help"

    When I follow "View"
    Then I should not see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should not see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should not see a sidebar titled "Help"


  Scenario: Create a sidebar for all except one action
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help, :except => :index do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should not see a sidebar titled "Help"

    When I follow "View"
    Then I should see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see a sidebar titled "Help"

  Scenario: Create a sidebar with deep content
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help do
        ul do
          li "First List First Item"
          li "First List Second Item"
        end
        ul do
          li "Second List First Item"
          li "Second List Second Item"
        end
      end
    end
    """
    When I am on the index page for posts
    Then I should see a sidebar titled "Help"
    And I should see "First List First Item" within "ul li"
    And I should see "Second List Second Item" within "ul li"

  Scenario: Rendering sidebar by default without a block or partial name
    Given "app/views/admin/posts/_help_sidebar.html.erb" contains:
    """
      <p>Hello World from a partial</p>
    """
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help
    end
    """
    When I am on the index page for posts
    Then I should see "Hello World from a partial" within ".sidebar_section"

  Scenario: Rendering a partial as the sidebar content
    Given "app/views/admin/posts/_custom_help_partial.html.erb" contains:
    """
      <p>Hello World from a partial</p>
    """
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help, :partial => "custom_help_partial"
    end
    """
    When I am on the index page for posts
    Then I should see "Hello World from a partial" within ".sidebar_section"

